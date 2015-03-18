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

require 'test_helper'

describe Advertisement do
  describe "バリデーション" do
    before { @advertisement = build(:advertisement) }

    describe "title" do
      valid_data = [1, 2, "a", "aaa", "あああ", "あ"*64]
      valid_data.each do |vd|
        context "title = #{vd}のとき" do
          before { @advertisement.title = vd }

          it "validであること" do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "あ"*65]
      invalid_data.each do |ivd|
        context "title = #{ivd}のとき" do
          before { @advertisement.title = ivd }

          it "invalidであること" do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe "summary" do
      valid_data = [1, 2, "a", "aaa", "あああ", "あ"*255]
      valid_data.each do |vd|
        context "summary = #{vd}のとき" do
          before { @advertisement.summary = vd }

          it "validであること" do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "あ"*256]
      invalid_data.each do |ivd|
        context "summary = #{ivd}のとき" do
          before { @advertisement.summary = ivd }

          it "invalidであること" do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe "body" do
      valid_data = [1, 2, "a", "aaa", "あああ"]
      valid_data.each do |vd|
        context "body = #{vd}のとき" do
          before { @advertisement.body = vd }

          it "validであること" do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, ""]
      invalid_data.each do |ivd|
        context "body = #{ivd}のとき" do
          before { @advertisement.body = ivd }

          it "invalidであること" do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe "started_on" do
      valid_data = ["2014/01/01", "2015-12-31", "2016/2/29"]
      valid_data.each do |vd|
        context "started_on = #{vd}のとき" do
          before { @advertisement.started_on = vd }

          it "validであること" do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "aaa", "あああ", "2015/2/29"]
      invalid_data.each do |ivd|
        context "started_on = #{ivd}のとき" do
          before { @advertisement.started_on = ivd }

          it "invalidであること" do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end



  end
end