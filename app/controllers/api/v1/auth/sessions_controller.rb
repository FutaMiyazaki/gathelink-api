class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  before_action :authenticate_api_v1_user!, only: %i[show_current_user]

  def guest_sign_in
    @resource = User.guest
    @token = @resource.create_token
    @resource.save!
    render_create_success
  end

  def show_current_user
    render status: :ok, json: current_api_v1_user
  end
end
