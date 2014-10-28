class InvitationMailer < ActionMailer::Base
  default from: "from@example.com"

  def invitation_mail(invitation)
    @invitation = invitation
    mail(to: @invitation.mail_address, subject: "Welcome to Everyone's Notice")
  end
end
