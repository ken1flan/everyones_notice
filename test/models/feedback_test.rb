# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  user_id    :integer          not null
#  url        :string
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_status      (status)
#  index_feedbacks_on_updated_at  (updated_at)
#  index_feedbacks_on_user_id     (user_id)
#

require 'test_helper'

describe Feedback do
  describe 'バリデーション' do
    before { @feedback = build(:feedback) }

    describe 'body' do
      valid_data = [1, 2, 'a', 'aaa', 'あああ']
      valid_data.each do |vd|
        context "body = #{vd}のとき" do
          before { @feedback.body = vd }

          it 'validであること' do
            @feedback.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '']
      invalid_data.each do |ivd|
        context "body = #{ivd}のとき" do
          before { @feedback.body = ivd }

          it 'invalidであること' do
            @feedback.invalid?.must_equal true
          end
        end
      end
    end

    describe 'user_id' do
      valid_data = [1, 2]
      valid_data.each do |vd|
        context "user_id = #{vd}のとき" do
          before { @feedback.user_id = vd }

          it 'validであること' do
            @feedback.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '', 'a']
      invalid_data.each do |ivd|
        context "user_id = #{ivd}のとき" do
          before { @feedback.user_id = ivd }

          it 'invalidであること' do
            @feedback.invalid?.must_equal true
          end
        end
      end
    end

    describe 'url' do
      valid_data = [1, 2, 'a', 'aaa', 'あああ', 'あ' * 255, '', nil]
      valid_data.each do |vd|
        context "url = #{vd}のとき" do
          before { @feedback.url = vd }

          it 'validであること' do
            @feedback.valid?.must_equal true
          end
        end
      end

      invalid_data = ['あ' * 256]
      invalid_data.each do |ivd|
        context "url = #{ivd}のとき" do
          before { @feedback.url = ivd }

          it 'invalidであること' do
            @feedback.invalid?.must_equal true
          end
        end
      end
    end
  end
end
