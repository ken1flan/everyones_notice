json.array!(@invitations) do |invitation|
  json.extract! invitation, :id, :mail_address, :message, :user_id, :token, :expired_at
  json.url invitation_url(invitation, format: :json)
end
