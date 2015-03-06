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

class PostImage < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader

  validates :title,
    presence: true,
    length: { maximum: 64 }

  validates :image,
    presence: true
end
