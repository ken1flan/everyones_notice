json.array!(@advertisements) do |advertisement|
  json.extract! advertisement, :id, :title, :summary, :body, :image, :started_on, :ended_on
  json.url advertisement_url(advertisement, format: :json)
end
