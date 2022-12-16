class Api::V1::FolderFavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_favorite, only: %i[destroy]
  before_action :correct_user, only: %i[destroy]

  def create
    favorite = FolderFavorite.new(folder_id: params[:folder_id], user_id: current_api_v1_user.id)
    if favorite.save
      folders = current_api_v1_user.favorited_folders.order_by('created_desc')
      render status: :created, json: {
        favorite: favorite.as_json(only: %i[id user_id]),
        folders: folders.as_json(include: [{ links: { only: %i[id title url] } }])
      }
    else
      render status: :internal_server_error, json: favorite.errors
    end
  end

  def destroy
    if @favorite.destroy
      render status: :no_content
    else
      render status: :internal_server_error, json: favorite.errors
    end
  end

  private

  def favorite_params
    params.permit(:folder_id)
  end

  def set_favorite
    @favorite = FolderFavorite.find(params[:id])
  end

  def correct_user
    render status: :forbidden, json: { message: "不正なリクエストです" } if current_api_v1_user.id != @favorite.user_id
  end
end
