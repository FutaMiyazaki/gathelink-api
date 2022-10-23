class Api::V1::FolderFavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :correct_user
  before_action :set_folder

  def create
    favorite = FolderFavorite.new(favorite_params)
    if favorite.save
      render status: :created,
             json: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                               only: %i[id])
    else
      render status: :internal_server_error, json: favorite.errors
    end
  end

  def destroy
    favorite = current_api_v1_user.folder_favorites.find_by!(folder_id: @folder.id)
    if favorite.destroy
      render status: :ok,
             json: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                               only: %i[id])
    else
      render status: :internal_server_error, json: favorite.errors
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :folder_id)
  end

  def correct_user
    if current_api_v1_user.id.to_s != favorite_params[:user_id]
      render status: :forbidden, json: { message: "不正なリクエストです" }
    end
  end

  def set_folder
    @folder = Folder.find(favorite_params[:folder_id])
    if @folder.id.to_s != favorite_params[:folder_id]
      render status: :forbidden,
             json: { message: "不正なリクエストです" }
    end
  end
end
