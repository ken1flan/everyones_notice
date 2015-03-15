# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  summary    :string           not null
#  body       :text             not null
#  image      :string
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
require "file_size_validator"

class Advertisement < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader

  validates :title,
    presence: true,
    length: { maximum: 64 }

  validates :summary,
    presence: true,
    length: { maximum: 255 }

  validates :body, presence: true

  validates :started_on, presence: true
  validates :ended_on, presence: true
    
  validates :image,
    file_size: { maximum: 3.megabytes.to_i }

end
