# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reply do
    notice_id 1
    body "MyText"
    user_id 1
  end
end
