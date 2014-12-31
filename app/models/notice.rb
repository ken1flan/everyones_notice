# == Schema Information
#
# Table name: notices
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  body         :text
#  user_id      :integer          not null
#  published_at :datetime
#  status       :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_notices_on_published_at  (published_at)
#  index_notices_on_user_id       (user_id)
#

class Notice < ActiveRecord::Base
  attr_accessible :title, :body, :user_id, :published_at, :status
  after_save :register_activity

  belongs_to :user
  has_many :replies
  has_many :notice_read_users
  has_many :read_users, through: :notice_read_users, source: :user
  has_many :activities

  has_reputation :likes, source: :user, aggregated_by: :sum
  include Liked

  scope :displayable, -> { where.not(published_at: nil) }
  scope :default_order, -> { order(published_at: :desc) }
  scope :today, -> { where("published_at > ?", 1.day.ago) }

  def published?
    self.published_at.present?
  end

  def draft?
    self.published_at.blank?
  end

  def read_by(user)
    self.read_users << user unless self.read_users.include? user
  end

  def unread_by(user)
    self.read_users.delete user if self.read_users.include? user
  end

  def read_by?(user)
    read_users.include? user
  end

  def read_user_number
    read_users.count
  end

  def unread_users
    User.where.not(id: read_users.pluck(:id))
  end

  def self.weekly_watched
    Notice.select("notices.*").
      joins(:activities).merge(
        Activity.
        select("notice_id, count(activities.id) AS count_id").
        where("activities.created_at >= ?", 1.week.ago).
        group(:notice_id)
      ).
      order("count_id DESC")
  end

  private
    def register_activity
      return if published_at.blank?
      return if Activity.find_by(
        type_id: Activity.type_ids[:notice], notice_id: id).present?

      begin
        activity = Activity.new
        activity.type_id = Activity.type_ids[:notice]
        activity.user_id = user_id
        activity.notice_id = id
        activity.save!
      rescue
        logger.warn("failed to register writing notice(id: #{self.id})")
      end
    end
end
