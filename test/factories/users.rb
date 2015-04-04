# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  nickname     :string(255)
#  club_id      :integer          default(1), not null
#  admin        :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  icon_url     :string(255)
#  belonging_to :string
#
# Indexes
#
#  index_users_on_club_id  (club_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence :nickname do
      |n| "nickname#{n}"
    end
    club_id 1
    admin false
    belonging_to { ('a'..'z').to_a.sample(15).join }
  end

  trait :admin do
    admin true
  end
end
