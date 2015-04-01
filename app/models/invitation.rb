# == Schema Information
#
# Table name: invitations
#
#  id           :integer          not null, primary key
#  mail_address :string(255)      not null
#  message      :text
#  club_id      :integer          not null
#  user_id      :integer
#  admin        :boolean          default("f"), not null
#  token        :string(255)      not null
#  expired_at   :datetime         not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Invitation < ActiveRecord::Base
  EXPIRATION_PERIOD = 3.days

  belongs_to :club
  belongs_to :user

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

  def user_registered?
    self.user_id.present?
  end

  def self.invalid_token?(token)
      invitation = Invitation.find_by(token: token)
      invitation.blank? ||
        invitation.expired? ||
        invitation.user_registered?
  end

  def self.valid_token?(token)
    !invalid_token?(token)
  end
end
