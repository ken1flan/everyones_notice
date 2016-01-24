# == Schema Information
#
# Table name: invitations
#
#  id           :integer          not null, primary key
#  mail_address :string(255)      not null
#  message      :text
#  club_id      :integer          not null
#  user_id      :integer
#  admin        :boolean          default(FALSE), not null
#  token        :string(255)      not null
#  expired_at   :datetime         not null
#  created_at   :datetime
#  updated_at   :datetime
#

class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  PAR_PAGE = 10

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = Invitation
                   .order('created_at DESC')
                   .page(params[:page]).per(PAR_PAGE)
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)

    @invitation.club_id = current_user.club_id

    respond_to do |format|
      if @invitation.save
        InvitationMailer.invitation_mail(@invitation).deliver_now

        format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
        format.json { render :show, status: :created, location: @invitation }
      else
        format.html { render :new }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url, notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    params.require(:invitation).permit(:mail_address, :message, :user_id, :token, :expired_at)
  end
end
