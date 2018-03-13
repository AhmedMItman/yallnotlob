class ApplicationController < ActionController::Base
  before_action :sanitize_devise_params, if: :devise_controller?
  protect_from_forgery with: :exception
  protected

  def sanitize_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image])
  end
end

def current_user
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
end