# == Schema Information
#
# Table name: activities
#
#  id                       :integer          not null, primary key
#  type_id                  :integer
#  user_id                  :integer
#  notice_id                :integer
#  reply_id                 :integer
#  created_at               :datetime
#  updated_at               :datetime
#  advertisement_id         :integer
#  activity_recordable_id   :integer
#  activity_recordable_type :string
#
# Indexes
#
#  index_activities_on_activity_recordable_reference  (activity_recordable_type,activity_recordable_id)
#  index_activities_on_created_at                     (created_at)
#  index_activities_on_notice_id                      (notice_id)
#  index_activities_on_reply_id                       (reply_id)
#  index_activities_on_type_id                        (type_id)
#  index_activities_on_user_id                        (user_id)
#  index_activities_unique_key                        (type_id,user_id,notice_id,reply_id) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    type_id { Activity.type_ids.sample }
    user
    notice
  end
end
