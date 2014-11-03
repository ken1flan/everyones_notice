class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  has_one :invitation

  def self.create_with_identity(auth, token)
    user = create!(nickname: auth[:info][:nickname])
    identity = Identity.create!({
      user_id: user.id,
      provider: auth[:provider],
      uid: auth[:uid]
    })

    invitation = Invitation.find_by(token: token)
    invitation.update_attributes(user_id: user.id)

    user
  end

  def self.find_from(auth)
    user = User.joins(:identities).
      merge(Identity.where(provider: auth[:provider], uid: auth[:uid])).
      first
  end
end
