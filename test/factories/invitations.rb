# == Schema Information
#
# Table name: invitations
#
#  id           :integer          not null, primary key
#  mail_address :string(255)      not null
#  message      :text
#  club_id      :integer          not null
#  user_id      :integer
#  admin        :boolean          default(FALSE), not null
#  token        :string(255)      not null
#  expired_at   :datetime         not null
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sequence :mail_address do |n|
      "hoge_#{n}@fuga.com"
    end
    message 'MyText'
    user_id nil
    club
    token 'MyString'
    expired_at { Invitation::EXPIRATION_PERIOD.since }

    trait :user_registered do
      user_id 1
    end

    factory :user_registered_invitation, traits: [:user_registered]
  end
end
