class Api::V1::FoldersController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]
  before_action :correct_user, only: %i[update destroy]

  def index
    folders = Folder.all
    render status: :ok, json: folders.as_json(include: [
                                                { user: { only: %i[id name] } },
                                                { links: { only: %i[id title url] } }
                                              ])
  end

  def show
    folder = Folder.find(params[:id])
    render status: :ok, json: { data: folder.as_json(include: [{ user: { only: %i[id name] } },
                                                               { links: { expect: %i[user_id] } }]) }
  end

  def create
    folder = current_api_v1_user.folders.build(folder_params)
    if folder.save
      render status: :ok, json: { data: folder.as_json(only: :id), message: "フォルダを作成しました" }
    else
      render status: :internal_server_error, json: { data: folder.errors, message: "フォルダの作成に失敗しました" }
    end
  end

  def update
    if @folder.update(folder_params)
      render status: :ok, json: { data: @folder.as_json(only: :id), message: "更新に成功しました" }
    else
      render status: :internal_server_error, json: { data: @folder.errors, message: "更新に失敗しました" }
    end
  end

  def destroy
    if @folder.destroy
      render status: :ok, json: { message: "削除に成功しました" }
    else
      render status: :internal_server_error, json: { data: @folder.errors, message: "削除に失敗しました" }
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end

  def correct_user
    @folder = Folder.find(params[:id])
    render status: :bad_request, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @folder.user_id
  end
end
