class SessionsController < ApplicationController
  def create
    if params[:new_user]
      @invitation = Invitation.find_by(token: params[:token])
      not_found if @invitation.blank? || @invitation.expired? || @invitation.user_id.present?

      @user = User.create_with_auth(auth_hash)
      @invitation.update_attributes(user_id: @user.id)

      session[:user_id] = @user.id
      redirect_to edit_user_path(@user)
    else
      @user = User.find_from(auth_hash)
      not_found if @user.blank?
      session[:user_id] = @user.id
      redirect_to '/'
    end
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end
