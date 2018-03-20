class ApplicationController < ActionController::Base
  before_action :sanitize_devise_params, if: :devise_controller?
  protect_from_forgery with: :exception
  # before_filter get_user_notifications
  before_action :get_user_notifications
  protected

  def sanitize_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image])
  end
end

def current_user
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
end

def get_user_notifications
	if current_user
		sql = "select notifications.id, notifications.message, notifications.from, notifications.typ, notifications.orderId, notifications.created_at from notifications, user_notifications where notifications.id = user_notifications.notification_id and user_id = " + current_user.id.to_s + " order by created_at desc"
		@notifications = ActiveRecord::Base.connection.execute(sql)
    # @notification = Notification.all
	end
	@notifications
end
