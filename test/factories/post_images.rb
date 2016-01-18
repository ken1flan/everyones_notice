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
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :post_image do
    user_id 1
    title 'MyString'
    image do
      fixture_file_upload Rails.root.join('test', 'fixtures', 'images', 'テスト画像.jpg')
    end
  end
end
