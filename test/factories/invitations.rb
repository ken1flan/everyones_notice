# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sequence :mail_address do |n|
      "hoge_#{n}@fuga.com"
    end
    message "MyText"
    user_id 1
    token "MyString"
    expired_at "2014-10-26 12:30:34"
  end
end
