class Invitation < ActiveRecord::Base
  EXPIRATION_PERIOD = 3.days

  before_create :generate_token

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64
    end while Invitation.exists?(token: self.token)
    self.expired_at = EXPIRATION_PERIOD.since
  end

  def expired?
    self.expired_at < Time.zone.now
  end
end
