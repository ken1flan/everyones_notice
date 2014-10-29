def set_auth_mock( provider, uid, nickname )
  OmniAuth.config.add_mock( provider, uid: uid, info: { nickname: nickname } )
end
