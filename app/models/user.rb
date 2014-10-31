class User < ActiveRecord::Base
  def self.create_with_auth(auth)
    user = create!(nickname: auth[:info][:nickname])
    identity = Identity.create!({
      user_id: user.id,
      provider: auth[:provider],
      uid: auth[:uid]
    })
  end
end
