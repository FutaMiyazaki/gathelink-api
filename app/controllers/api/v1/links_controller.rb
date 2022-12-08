require "mechanize"
require "uri"

class Api::V1::LinksController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[show create update destroy]
  before_action :correct_user_folder, only: %i[create update]
  before_action :correct_user_link, only: %i[show update destroy]

  def index
    links = Link.all
    render status: :ok, json: links
  end

  def show
    link = Link.find(params[:id])
    folders = current_api_v1_user.folders
    render status: :ok, json: {
      link: link.as_json,
      folders: folders.as_json(only: %i[id name])
    }
  end

  def create
    link = current_api_v1_user.links.build(link_params)
    if scraping(link.url)
      @page = scraping(link.url)
      link["image_url"] = @page.at('meta[property="og:image"]')[:content] if @page&.at('meta[property="og:image"]')
    end
    if link.title.blank?
      link.title = @page&.title ? @page.title : URI.parse(link.url).host
    end
    if link.save!
      render status: :created, json: {
        folder: @folder.as_json(only: %i[id]),
        link: link.as_json(expect: %i[user_id created_at])
      }
    else
      render status: :internal_server_error, json: link.errors
    end
  end

  def update
    if link_params[:title].blank? || @link.url != link_params[:url]
      @link.assign_attributes(link_params)
      if scraping(link_params[:url]) && @page&.at('meta[property="og:image"]')
        @link["image_url"] = @page.at('meta[property="og:image"]')[:content]
      end
      if link_params[:title].blank?
        @link.title = @page&.title ? @page.title : URI.parse(@link.url).host
      end
    end
    if @link.update(link_params)
      render status: :no_content
    else
      render status: :internal_server_error, json: new_link.errors
    end
  end

  def destroy
    if @link.destroy
      render status: :no_content
    else
      render status: :internal_server_error, json: @link.errors
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :image_url, :folder_id)
  end

  def correct_user_folder
    @folder = Folder.find(link_params[:folder_id])
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @folder.user_id
  end

  def correct_user_link
    @link = Link.find(params[:id])
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @link.user_id
  end

  def scraping(url)
    agent = Mechanize.new
    # HTML情報の取得でエラーが発生した場合、代わりにURLからタイトルを代入するために、例外処理を入れて無視させる
    begin
      @page = agent.get(url)
    rescue Timeout::Error, Errno::EADDRNOTAVAIL, Mechanize::ResponseCodeError
      nil
    end
  end
end
