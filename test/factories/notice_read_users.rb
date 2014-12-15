# == Schema Information
#
# Table name: notice_read_users
#
#  id         :integer          not null, primary key
#  notice_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_notice_read_users_on_notice_id  (notice_id)
#  index_notice_read_users_on_user_id    (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notice_read_user do
    notice nil
    user nil
  end
end
