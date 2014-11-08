FactoryGirl.define do
  factory :notice do
    title { "title" + ('a'..'z').to_a.sample(26).join }
    body { "body" + ('a'..'z').to_a.sample(26).join }
    user_id 1
    published_at nil
    status 1
  end
end
