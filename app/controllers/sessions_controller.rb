class SessionsController < ApplicationController
  def create
    if params[:new_user]
      not_found if Invitation.invalid_token? params[:token]

      @user = User.create_with_identity(auth_hash, params[:token])

      session[:user_id] = @user.id
      redirect_to edit_user_path(@user)
    else
      @user = User.find_from(auth_hash)
      not_found if @user.blank?
      session[:user_id] = @user.id
      redirect_to "/"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", notice: "ログアウトしました"
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end
