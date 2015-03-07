# == Schema Information
#
# Table name: post_images
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  image      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_post_images_on_created_at  (created_at)
#  index_post_images_on_user_id     (user_id)
#
require "file_size_validator"

class PostImage < ActiveRecord::Base
  belongs_to :user
  VALID_IMAGE_TYPES = %w(image/jpeg image/png)

  mount_uploader :image, ImageUploader

  validates :title,
    presence: true,
    length: { maximum: 64 }

  validates :image,
    presence: true,
    file_size: { maximum: 3.megabytes.to_i }
  validate :valid_file_type?

  def valid_file_type?
    return if image.blank?

    unless VALID_IMAGE_TYPES.include? image.file.content_type 
      errors.add :image, I18n.t("errors.messages.invalid_image_type")
    end
  end
end
