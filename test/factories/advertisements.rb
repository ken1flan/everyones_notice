FactoryGirl.define do
  factory :advertisement do
    title { "title" + ('a'..'z').to_a.sample(26).join }
    summary { "summary" + ('a'..'z').to_a.sample(26).join }
    body { "body" + ('a'..'z').to_a.sample(26).join }
    started_on { (rand(10) + 1).days.since.to_date }
    ended_on { (rand(10) + 10).days.since.to_date }
  end
end
