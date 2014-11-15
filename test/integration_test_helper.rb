def set_auth_mock( provider, uid, nickname )
  OmniAuth.config.add_mock( provider, uid: uid, info: { nickname: nickname } )
end

def create_user_and_identity(provider)
  user = create(:user)
  create(:identity, user_id: user.id, provider: provider)
  user
end

def login(user = nil)
  user ||= create_user_and_identity("twitter")
  set_auth_mock("twitter", user.identities.first.uid, user.nickname)
  visit "/auth/twitter"
  user
end
