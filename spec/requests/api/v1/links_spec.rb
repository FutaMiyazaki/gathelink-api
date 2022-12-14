require 'rails_helper'

RSpec.describe "Api::V1::Links", type: :request do
  let!(:others_folder) { create(:folder) }
  let!(:user) { create(:user, :with_folders) }
  let!(:auth_token) { user.create_new_auth_token }
  let!(:folder) { create(:folder, user_id: user.id) }
  let!(:link) { create(:link, user_id: user.id) }
  let!(:others_link) { create(:link) }

  describe "GET /api/v1/links/:id" do
    it "リクエストが成功すること" do
      get api_v1_link_path(link.id), headers: auth_token
      expect(response).to have_http_status(:success)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      get api_v1_link_path(link.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "リンクの作成ユーザと異なるユーザからのリクエストの場合、リクエストが失敗すること" do
      get api_v1_link_path(others_link.id), headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/links" do
    it "リクエストが成功すること" do
      folder = user.folders.find_by(name: "テストユーザのフォルダ")
      post api_v1_links_path,
           params: { link:
            { url: "https://gathelink.app", title: "gathelinkのurlです", folder_id: folder.id } },
           headers: auth_token
      expect(response).to have_http_status(:created)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      folder = user.folders.find_by(name: "テストユーザのフォルダ")
      post api_v1_links_path, params: { link: { url: "https://gathelink.app", title: "gathelinkのurlです", folder_id: folder.id } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "フォルダ所収者と異なるユーザの場合、リクエストが失敗すること" do
      post api_v1_links_path,
           params: { link: { url: "https://gathelink.app", title: "gathelinkのurlです", folder_id: others_folder.id } },
           headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/links/:id" do
    it "リクエストが成功すること" do
      patch api_v1_link_path(link.id), params: { link: { url: "https://gathelink.app/new",
                                                         title: "urlを変更しました",
                                                         folder_id: folder.id } },
                                       headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      patch api_v1_link_path(link.id), params: { link: { url: "https://gathelink.app/new",
                                                         title: "urlを変更しました",
                                                         folder_id: folder.id } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "所有者でない場合、リクエストが失敗すること" do
      patch api_v1_link_path(others_link.id),
            params: { link: { url: "https://gathelink.app/new", title: "urlを変更しました", folder_id: others_folder.id } },
            headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/links/:id" do
    it "リクエストが成功すること" do
      delete api_v1_link_path(link.id), headers: auth_token
      expect(response).to have_http_status(:no_content)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      delete api_v1_link_path(link.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "所有者でない場合、リクエストが失敗すること" do
      delete api_v1_link_path(others_link.id), headers: auth_token
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/v1/my_links" do
    it "リクエストが成功すること" do
      get api_v1_my_links_path, headers: auth_token
      expect(response).to have_http_status(:success)
    end

    it "ヘッダに認証情報が存在しない場合、リクエストが失敗すること" do
      get api_v1_my_links_path
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
