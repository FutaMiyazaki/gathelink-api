require 'rails_helper'

RSpec.describe "Api::V1::FolderFavorites", type: :request do
  let!(:user) { create(:user) }
  let!(:auth_token) { user.create_new_auth_token }
  let!(:folder) { create(:folder, user_id: user.id) }
  let!(:unrelated_folder) { create(:folder) }
  let!(:params) { { user_id: user.id, folder_id: folder.id } }

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

  describe "DELETE /api/v1/folder_favorites" do
    it "リクエストが成功すること" do
      post api_v1_folder_favorites_path, params: { folder_id: folder.id }, headers: auth_token
      delete api_v1_folder_favorites_path, params:  { folder_id: folder.id }, headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      post api_v1_folder_favorites_path, params:  { folder_id: folder.id }, headers: auth_token
      delete api_v1_folder_favorites_path, params:  { folder_id: folder.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "お気に入り登録していない folder_id を渡した場合、リクエストが失敗すること" do
      post api_v1_folder_favorites_path, params:  { folder_id: folder.id }, headers: auth_token
      delete api_v1_folder_favorites_path, params: { folder_id: unrelated_folder.id },
                                           headers: auth_token
      expect(response).to have_http_status(:not_found)
    end
  end
end
