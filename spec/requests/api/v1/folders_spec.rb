require 'rails_helper'

RSpec.describe "Api::V1::Folders", type: :request do
  let!(:user) { create(:user, :with_folders) }
  let!(:auth_token) { user.create_new_auth_token }
  let!(:folder) { create(:folder, user_id: user.id) }
  let!(:unrelated_folder) { create(:folder) }
  let!(:params) { { name: "gathelinkのフォルダ" } }

  describe "GET /api/v1/folders" do
    it "リクエストが成功すること" do
      get api_v1_folders_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/folders" do
    it "リクエストが成功すること" do
      post api_v1_folders_path, params: { folder: params }, headers: auth_token
      expect(response).to have_http_status(:created)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      post api_v1_folders_path, params: { folder: params }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/folders/:id" do
    it "リクエストが成功すること" do
      patch api_v1_folder_path(folder.id), params: { folder: { name: "フォルダ名を変更" } }, headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      patch api_v1_folder_path(folder.id), params: { folder: { name: "フォルダ名を変更" } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "所有者でない場合、リクエストが失敗すること" do
      patch api_v1_folder_path(unrelated_folder.id), params: { folder: { name: "フォルダ名を変更" } }, headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/folders/:id" do
    it "リクエストが成功すること" do
      delete api_v1_folder_path(folder.id), headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      delete api_v1_folder_path(folder.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "所有者でない場合、リクエストが失敗すること" do
      delete api_v1_folder_path(unrelated_folder.id), headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/v1/my_folder" do
    it "リクエストが成功すること" do
      get api_v1_my_folder_list_path, headers: auth_token
      expect(response).to have_http_status(:success)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      get api_v1_my_folder_list_path
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
