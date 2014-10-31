class SessionsController < ApplicationController
  def create
    if params[:new_user]
      @user = User.create_with_auth(auth_hash)
      self.current_user = @user
      redirect_to edit_user(@user)
    else
      @user = User.find_from(auth_hash)
      self.current_user = @user
      redirect_to '/'
    end
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end
