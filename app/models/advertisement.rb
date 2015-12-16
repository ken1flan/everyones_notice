# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  summary    :string           not null
#  body       :text             not null
#  started_on :date             not null
#  ended_on   :date             not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_advertisements_on_started_on_and_ended_on  (started_on,ended_on)
#  index_advertisements_on_updated_at               (updated_at)
#

class Advertisement < ActiveRecord::Base
  belongs_to :user
  after_save :register_activity

  has_many :approvals, as: :approvable

  include Liked

  scope :displayable, -> {
    where(arel_table[:started_on].lteq Date.today).
    where(arel_table[:ended_on].gteq Date.today)
  }

  validates :title,
    presence: true,
    length: { maximum: 64 }

  validates :summary,
    presence: true,
    length: { maximum: 255 }

  validates :body, presence: true

  validates :started_on, presence: true, date: true
  validates :ended_on, presence: true, date: true

  private
    def register_activity
      return if Activity.find_by(
        type_id: Activity.type_ids[:advertisement],
        advertisement_id: id
      ).present?

      begin
        activity = Activity.new
        activity.type_id = Activity.type_ids[:advertisement]
        activity.user_id = user_id
        activity.advertisement_id = id
        activity.save!
      rescue
        logger.warn("failed to register writing advertisement(id: #{self.id}")
      end
    end
end
