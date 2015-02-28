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

class Feedback < ActiveRecord::Base
  belongs_to :user

  enum status: { unclassified: 0, opened: 1, closed: 2 }

  validates :title,
    presence: true,
    length: { maximum: 64 }
  validates :body,
    presence: true
  validates :user_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }
  validates :url,
    length: { maximum: 255 }
end
