class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :user_signed_in?, :current_user, :markdown_to_html

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def require_login
    redirect_to login_path unless current_user
  end

  def markdown_to_html(markdown_text)
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(hard_wrap: true),
      autolink: true
    )
    @markdown.render markdown_text
  end
end
