require 'rails_helper'

RSpec.describe "Api::V1::FolderFavorites", type: :request do
  let!(:user) { create(:user) }
  let!(:auth_token) { user.create_new_auth_token }
  let!(:folder) { create(:folder) }
  let!(:folder_favorite) { create(:folder_favorite, user_id: user.id) }
  let!(:others_folder_favorite) { create(:folder_favorite) }

  describe "POST /api/v1/folder_favorites" do
    it "リクエストが成功すること" do
      post api_v1_folder_favorites_path, params: { folder_id: folder.id }, headers: auth_token
      expect(response).to have_http_status(:created)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      post api_v1_folder_favorites_path, params: { folder_id: folder.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/folder_favorite" do
    it "リクエストが成功すること" do
      delete api_v1_folder_favorite_path(folder_favorite.id), headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      delete api_v1_folder_favorite_path(folder_favorite.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "お気に入り登録していない folder_id を渡した場合、リクエストが失敗すること" do
      delete api_v1_folder_favorite_path(others_folder_favorite.id), headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end
end
