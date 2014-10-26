class Invitation < ActiveRecord::Base
  EXPIRATION_PERIOD = 3.days

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64
    end while Invitation.exists?(token: self.token)
    self.expired_at = EXPIRATION_PERIOD.ago
  end
end
