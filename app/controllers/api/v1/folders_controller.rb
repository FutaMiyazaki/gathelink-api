class Api::V1::FoldersController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update destroy my_folder_list]
  before_action :correct_user, only: %i[update destroy]

  def index
    folders = Folder.all
    render status: :ok, json: folders.as_json(include: [
                                                { user: { only: %i[id name] } },
                                                { links: { expect: %i[user_id] } }
                                              ])
  end

  def show
    folder = Folder.find(params[:id])
    is_owner = api_v1_user_signed_in? ? folder.user_id == current_api_v1_user.id : false
    render status: :ok, json: {
      folder: folder.as_json({ include: [{ user: { only: %i[id name email] } },
                                         { folder_favorites: { only: %i[id user_id] } }],
                               methods: :old_order_links }),
      is_owner:
    }
  end

  def create
    folder = current_api_v1_user.folders.build(folder_params)
    if folder.save
      render status: :created, json: folder.as_json(expect: %i[user_id])
    else
      render status: :internal_server_error, json: folder.errors
    end
  end

  def update
    if @folder.update(folder_params)
      render status: :no_content
    else
      render status: :internal_server_error, json: @folder.errors
    end
  end

  def destroy
    if @folder.destroy
      render status: :no_content
    else
      render status: :internal_server_error, json: @folder.errors
    end
  end

  def my_folder_list
    folders = case params[:sort]
              when "latest"
                current_api_v1_user.folders.latest
              else
                current_api_v1_user.folders.old
              end
    render status: :ok, json: folders.as_json(include: :links)
  end

  def favorited_folders_list
    folders = case params[:sort]
              when "latest"
                current_api_v1_user.favorited_folders.latest
              else
                current_api_v1_user.favorited_folders.old
              end
    render status: :ok, json: folders.as_json(include: :links)
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :description)
  end

  def correct_user
    @folder = Folder.find(params[:id])
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @folder.user_id
  end
end
