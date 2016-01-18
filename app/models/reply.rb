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
  after_save :register_activity, :index_notice

  belongs_to :user
  belongs_to :notice
  has_many :approvals, as: :approvable

  include Liked

  validates :notice_id,
            presence: true,
            numericality: { allow_blank: true, greater_than: 0 }
  validates :body,
            presence: true
  validates :user_id,
            presence: true,
            numericality: { allow_blank: true, greater_than: 0 }

  private

  def register_activity
    return if Activity.find_by(
      type_id: Activity.type_ids[:reply], reply_id: id).present?

    begin
      activity = Activity.new
      activity.type_id = Activity.type_ids[:reply]
      activity.user_id = user_id
      activity.notice_id = notice_id
      activity.reply_id = id
      activity.save!
    rescue
      logger.warn("failed to register writing notice(id: #{id})")
    end
  end

  def index_notice
    Notice.reindex
    Sunspot.commit
  end
end
