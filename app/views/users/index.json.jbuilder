json.array!(@users) do |user|
  json.extract! user, :id, :nickname, :club_id
  json.url user_url(user, format: :json)
end
