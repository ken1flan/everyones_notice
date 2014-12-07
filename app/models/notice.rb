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

  belongs_to :user
  has_many :replies
  has_reputation :likes, source: :user, aggregated_by: :sum
  has_reputation :opened, source: :user, aggregated_by: :sum
  include Liked
  include Opened

  scope :displayable, -> { where.not(published_at: nil) }
  scope :default_order, -> { order(published_at: :desc) }

  def published?
    self.published_at.present?
  end

  def draft?
    self.published_at.blank?
  end
end
