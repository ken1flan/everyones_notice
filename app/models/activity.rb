# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  type_id          :integer
#  user_id          :integer
#  notice_id        :integer
#  reply_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  advertisement_id :integer
#
# Indexes
#
#  index_activities_on_created_at  (created_at)
#  index_activities_on_notice_id   (notice_id)
#  index_activities_on_reply_id    (reply_id)
#  index_activities_on_type_id     (type_id)
#  index_activities_on_user_id     (user_id)
#  index_activities_unique_key     (type_id,user_id,notice_id,reply_id) UNIQUE
#

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :notice
  belongs_to :reply
  belongs_to :advertisement

  enum type_id: { notice: 1, reply: 2, thumbup_notice: 3, thumbup_reply: 4, advertisement: 5 }

  scope :default_order, -> { order("created_at DESC") }
  scope :between_beginning_and_end_of_day, -> (target_date) do
    if target_date.present?
      where(created_at: target_date.beginning_of_day..target_date.end_of_day)
    end
  end

  scope :related_user, -> (user) do
    joins_related_models.
    where("
          activities.user_id = ? OR
          notices.user_id = ? OR
          replies.user_id = ? OR
          advertisements.user_id = ?",
          user.id, user.id, user.id, user.id
         )
  end

  scope :joins_related_models, -> do
    joins("LEFT JOIN notices ON activities.notice_id = notices.id").
    joins("LEFT JOIN replies ON activities.reply_id = replies.id").
    joins("LEFT JOIN advertisements ON activities.advertisement_id = advertisements.id")
  end

  def self.permit(params)
    params.require(:activity).permit(:notice_id, :user_id)
  end
end
