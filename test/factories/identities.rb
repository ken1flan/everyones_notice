# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    user_id 1
    provider "twitter"
    uid { "uid#{rand(10000)}" }
  end
end
