require 'rails_helper'

RSpec.describe "Api::V1::Links", type: :request do
  let(:link_params) { attributes_for(:link) }
  let(:params) do
    {
      url: "https://gathelink.app",
      title: "gathelinkのurlです"
    }
  end

  describe "GET /api/v1/links" do
    it "リクエストが成功すること" do
      get api_v1_links_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/links" do
    it "リクエストが成功すること" do
      post api_v1_links_path, params: { link: link_params }
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /api/v1/links" do
    let!(:link) { create(:link) }

    it "リクエストが成功すること" do
      delete api_v1_link_path(link.id)
      expect(response).to have_http_status(:success)
    end
  end
end
