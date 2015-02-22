class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :user_signed_in?, :can_manage_users?, :current_user, :markdown_to_html

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def user_signed_in?
    current_user.present?
  end

  def can_manage_users?
    !!current_user.admin
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def require_login
    redirect_to login_path unless current_user
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer:language)
      end
    end
  end

  def markdown_to_html(markdown_text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(markdown_text).html_safe
  end
end
