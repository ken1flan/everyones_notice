class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :current_user

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def require_login
    redirect_to login_path unless current_user
  end
end
