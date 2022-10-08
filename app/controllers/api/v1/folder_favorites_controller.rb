class Api::V1::FolderFavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :correct_user
  before_action :set_folder

  def create
    favorite = FolderFavorite.new(favorite_params)
    if favorite.save
      render status: :created,
             json: {
               data: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                                 only: %i[id]), message: "お気に入り登録しました"
             }
    else
      render status: :internal_server_error, json: { data: favorite.errors, message: "お気に入り登録に失敗しました" }
    end
  end

  def destroy
    favorite = current_api_v1_user.folder_favorites.find_by!(folder_id: @folder.id)
    if favorite.destroy
      render status: :ok,
             json: {
               data: current_api_v1_user.as_json(include: [{ favorite_folders: { expect: %i[created_at updated_at] } }],
                                                 only: %i[id]), message: "お気に入りから削除しました"
             }
    else
      render status: :internal_server_error, json: { data: favorite.errors, message: "お気に入り解除に失敗しました" }
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :folder_id)
  end

  def correct_user
    if current_api_v1_user.id.to_s != favorite_params[:user_id]
      render status: :bad_request,
             json: { message: "不正なリクエストです" }
    end
  end

  def set_folder
    @folder = Folder.find(favorite_params[:folder_id])
    if @folder.id.to_s != favorite_params[:folder_id]
      render status: :bad_request,
             json: { message: "不正なリクエストです" }
    end
  end
end
