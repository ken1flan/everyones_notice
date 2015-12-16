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

require 'test_helper'

describe PostImage do
  describe "バリデーション" do
    before { @post_image = build(:post_image) }

    describe "title" do
      valid_data = [1, 2, "a", "aaa", "あああ", "あ"*64]
      valid_data.each do |vd|
        context "title = #{vd}のとき" do
          before { @post_image.title = vd }

          it "validであること" do
            @post_image.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "あ"*65]
      invalid_data.each do |ivd|
        context "title = #{ivd}のとき" do
          before { @post_image.title = ivd }

          it "invalidであること" do
            @post_image.invalid?.must_equal true
          end
        end
      end
    end

    describe "image" do
      context "nilのとき" do
        before { @post_image = build(:post_image, title:"タイトル", image: nil) }

        it "invalidであること" do
          @post_image.valid?.must_equal false
        end
      end

      valid_ext = %w(jpg jpeg JPG png PNG)
      valid_ext.each do |ext|
        context "jpgが指定されているとき" do
          before do
            image = open Rails.root.join("test", "fixtures", "images", "テスト画像.#{ext}")
            @post_image = build(:post_image, title:"タイトル", image: image)
          end

          it "validであること" do
            @post_image.valid?.must_equal true
          end
        end
      end

      invalid_ext = %w(bmp txt zip)
      invalid_ext.each do |ext|
        context "bmpが指定されているとき" do
          before do
            image = open Rails.root.join("test", "fixtures", "images", "テスト画像.#{ext}")
            @post_image = build(:post_image, title:"タイトル", image: image)
          end

          it "invalidであること" do
            @post_image.valid?.must_equal false
          end
        end
      end

      context "3MB以上の画像データを指定したとき" do
        before do
          image = open Rails.root.join("test", "fixtures", "images", "3MBテスト画像.jpg")
          @post_image = build(:post_image, title:"タイトル", image: image)
        end

        it "invalidであること" do
          @post_image.valid?.must_equal false
        end
      end
    end
  end
end
