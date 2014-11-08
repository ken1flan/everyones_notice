json.array!(@notices) do |notice|
  json.extract! notice, :id, :title, :body, :user_id, :published_at, :status
  json.url notice_url(notice, format: :json)
end
