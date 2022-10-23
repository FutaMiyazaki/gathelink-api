class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    I18n.locale = :ja
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: '404 not found' }, status: :not_found
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name image])
  end
end
