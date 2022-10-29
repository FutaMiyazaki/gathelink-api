class Api::V1::FolderFavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_favorite, only: %i[destroy]
  before_action :correct_user, only: %i[destroy]

  def create
    favorite = FolderFavorite.new(folder_id: params[:folder_id], user_id: current_api_v1_user.id)
    if favorite.save
      render status: :created,
             json: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                               only: %i[id])
    else
      render status: :internal_server_error, json: favorite.errors
    end
  end

  def destroy
    if @favorite.destroy
      render status: :no_content,
             json: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                               only: %i[id])
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
