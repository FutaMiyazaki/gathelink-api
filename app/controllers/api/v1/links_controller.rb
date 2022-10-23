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
      link: link.as_json(only: %i[id title url]),
      folders: folders.as_json(only: %i[id name])
    }
  end

  def create
    link = current_api_v1_user.links.build(link_params)
    if link.save
      render status: :created, json: @folder.as_json(include: [{ links: { expect: %i[user_id created_at] } }])
    else
      render status: :internal_server_error, json: link.errors
    end
  end

  def update
    if @link.update(link_params)
      render status: :ok, json: @link.as_json(only: %i[id title])
    else
      render status: :internal_server_error, json: @link.errors
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
    params.require(:link).permit(:url, :title, :folder_id)
  end

  def correct_user_folder
    @folder = Folder.find(link_params[:folder_id])
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @folder.user_id
  end

  def correct_user_link
    @link = Link.find(params[:id])
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @link.user_id
  end
end
