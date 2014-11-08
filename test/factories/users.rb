# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence :nickname do
      |n| "nickname#{n}"
    end
    club_id 1
  end
end
