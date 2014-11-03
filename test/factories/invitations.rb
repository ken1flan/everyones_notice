# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sequence :mail_address do |n|
      "hoge_#{n}@fuga.com"
    end
    message "MyText"
    user_id nil
    token "MyString"
    expired_at { Invitation::EXPIRATION_PERIOD.since }
    
    trait :user_registered do
      user_id 1
    end

    factory :user_registered_invitation, traits: [ :user_registered ]
  end
end
