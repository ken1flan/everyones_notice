# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    mail_address "MyString"
    message "MyText"
    user_id 1
    token "MyString"
    expired_at "2014-10-26 12:30:34"
  end
end
