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
  before_save :create_tags
  after_save :register_activity

  attr_accessor :tags_string

  belongs_to :user
  has_many :replies
  has_many :notice_read_users
  has_many :read_users, through: :notice_read_users, source: :user
  has_many :notice_tags
  has_many :tags, through: :notice_tags
  has_many :activities
  has_many :approvals, as: :approvable

  include Liked

  scope :displayable, -> { where.not(published_at: nil) }
  scope :default_order, -> { order(published_at: :desc) }
  scope :today, -> { where('published_at > ?', 1.day.ago) }

  searchable do
    text :user_nickname do
      user.nickname
    end
    text :title, :body
    text :replies do
      replies.map(&:body)
    end
    boolean :published do
      published_at.present?
    end
  end

  validates :title,
            presence: true,
            length: { maximum: 64 }
  validates :body,
            presence: true
  validates :user_id,
            presence: true,
            numericality: { allow_blank: true, greater_than: 0 }

  def published?
    published_at.present?
  end

  def draft?
    published_at.blank?
  end

  def read_by(user)
    read_users << user unless read_users.include? user
  end

  def unread_by(user)
    read_users.delete user if read_users.include? user
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

  def previous
    @previous ||= Notice.displayable.where('id < ?', id).order('id DESC').first
    @previous
  end

  def next
    @next ||= Notice.displayable.where('id > ?', id).order('id ASC').first
    @next
  end

  def tags_string
    @tags_string ||= tags.map(&:name).join(',')
  end

  def self.weekly_watched
    Notice.select('notices.*')
          .joins(:activities).merge(
            Activity
            .select('notice_id, count(activities.id) AS count_id')
            .where('activities.created_at >= ?', 1.week.ago)
            .group(:notice_id)
          )
          .order('count_id DESC')
  end

  private

  def create_tags
    self.tags = tags_string.split(',').map do |tag_name|
      Tag.find_or_create_by(name: tag_name)
    end
  end

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
      logger.warn("failed to register writing notice(id: #{id})")
    end
  end
end
