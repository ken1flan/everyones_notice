class LoginsController < ApplicationController
  layout 'no_header'
  skip_filter :require_login

  def show
    redirect_to root_path if current_user
  end
end
