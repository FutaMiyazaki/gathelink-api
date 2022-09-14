require 'rails_helper'

RSpec.describe "Api::V1::Links", type: :request do
  let(:link_params) { attributes_for(:link) }
  let(:params) { { url: "https://gathelink.app", title: "gathelinkのurlです" } }

  describe "GET /api/v1/links" do
    it "リクエストが成功すること" do
      get api_v1_links_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/links" do
    let!(:user) { create(:user) }
    let!(:auth_token) { user.create_new_auth_token }

    it "リクエストが成功すること" do
      post api_v1_links_path, params: { link: link_params }, headers: auth_token
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /api/v1/links" do
    let!(:user) { create(:user) }
    let!(:auth_token) { user.create_new_auth_token }
    let!(:link) { create(:link, user_id: user.id) }

    it "リクエストが成功すること" do
      patch api_v1_link_path(link.id), params: { link: { url: "https://gathelink.app/new", title: "urlを変更しました" } },
                                       headers: auth_token
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /api/v1/links" do
    let!(:user) { create(:user) }
    let!(:auth_token) { user.create_new_auth_token }
    let!(:link) { create(:link, user_id: user.id) }

    it "リクエストが成功すること" do
      delete api_v1_link_path(link.id), headers: auth_token
      expect(response).to have_http_status(:success)
    end
  end
end
