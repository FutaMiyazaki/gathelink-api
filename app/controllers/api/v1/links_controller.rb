class Api::V1::LinksController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]
  before_action :correct_user_folder, only: %i[create]
  before_action :correct_user_link, only: %i[update destroy]

  def index
    links = Link.all
    render status: :ok, json: { data: links }
  end

  def create
    link = current_api_v1_user.links.build(link_params)
    if link.save
      render status: :created, json: { data: link }
    else
      render status: :internal_server_error, json: { data: link.errors, message: "リンクの作成に失敗しました" }
    end
  end

  def update
    if @link.update(link_params)
      render status: :created, json: { data: @link }
    else
      render status: :internal_server_error, json: { data: @link.errors, message: "更新に失敗しました" }
    end
  end

  def destroy
    if @link.destroy
      render status: :no_content
    else
      render status: :internal_server_error, json: { data: @link.errors, message: "削除に失敗しました" }
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :folder_id)
  end

  def correct_user_folder
    folder = Folder.find(link_params[:folder_id])
    render status: :bad_request, json: { message: "不正なリクエストです" } if current_api_v1_user.id != folder.user_id
  end

  def correct_user_link
    @link = Link.find(params[:id])
    render status: :bad_request, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @link.user_id
  end
end
