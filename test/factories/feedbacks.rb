# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  user_id    :integer          not null
#  url        :string
#  status     :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_status      (status)
#  index_feedbacks_on_updated_at  (updated_at)
#  index_feedbacks_on_user_id     (user_id)
#

FactoryGirl.define do
  factory :feedback do
    body "MyText"
    user_id 1
    url "MyString"
    status 1
  end

end
