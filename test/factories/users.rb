# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)
#  club_id    :integer          default(1), not null
#  admin      :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
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
  end
end
