require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/auth/guest_sign_in" do
    context "リクエストが送信された時" do
      subject(:request) { post(api_v1_auth_guest_sign_in_path) }

      it "ゲストログインできる" do
        request
        expect(response).to have_http_status(:ok)
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end
  end
end
