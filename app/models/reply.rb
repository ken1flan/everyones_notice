# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  notice_id  :integer          not null
#  body       :text             not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_replies_on_notice_id  (notice_id)
#  index_replies_on_user_id    (user_id)
#

class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :notice

  validates :notice_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }
  validates :body,
    presence: true
  validates :user_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }
end
