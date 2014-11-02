class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy

  def self.create_with_auth(auth)
    user = create!(nickname: auth[:info][:nickname])
    identity = Identity.create!({
      user_id: user.id,
      provider: auth[:provider],
      uid: auth[:uid]
    })
    user
  end

  def self.find_from(auth)
    user = User.joins(:identities).
      merge(Identity.where(provider: auth[:provider], uid: auth[:uid])).
      first
  end
end
