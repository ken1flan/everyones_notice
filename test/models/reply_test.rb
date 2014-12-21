# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  notice_id  :integer          not null
#  body       :text             not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_replies_on_notice_id  (notice_id)
#  index_replies_on_user_id    (user_id)
#

require 'test_helper'

describe Reply do
  describe "バリデーション" do
    before { @reply_data = build(:reply) }

    describe "notice_id" do
      valid_data = [1, 2]
      valid_data.each do |vd|
        context "notice_id = #{vd}のとき" do
          before { @reply_data.notice_id = vd }

          it "validであること" do
            @reply_data.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "a"]
      invalid_data.each do |ivd|
        context "notice_id = #{ivd}のとき" do
          before { @reply_data.notice_id = ivd }

          it "invalidであること" do
            @reply_data.invalid?.must_equal true
          end
        end
      end
    end

    describe "body" do
      valid_data = [1, 2, "a", "aaa", "あああ"]
      valid_data.each do |vd|
        context "body = #{vd}のとき" do
          before { @reply_data.body = vd }

          it "validであること" do
            @reply_data.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, ""]
      invalid_data.each do |ivd|
        context "body = #{ivd}のとき" do
          before { @reply_data.body = ivd }

          it "invalidであること" do
            @reply_data.invalid?.must_equal true
          end
        end
      end
    end

    describe "user_id" do
      valid_data = [1, 2]
      valid_data.each do |vd|
        context "user_id = #{vd}のとき" do
          before { @reply_data.user_id = vd }

          it "validであること" do
            @reply_data.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, "", "a"]
      invalid_data.each do |ivd|
        context "user_id = #{ivd}のとき" do
          before { @reply_data.user_id = ivd }

          it "invalidであること" do
            @reply_data.invalid?.must_equal true
          end
        end
      end
    end
  end

  describe "#register_activity" do
    context "replyをcreateしたとき" do
      before do
        @reply = create(:reply)
        @activity_count = Activity.count
        @activity = Activity.find_by(type_id: Activity::type_ids[:reply], reply_id: @reply.id)
      end

      it "Activityにユーザが登録されていること" do
        @activity.user_id.must_equal @reply.user_id
      end

      context "replyを更新したとき" do
        before { @reply.update_attributes(body: "更新内容") }

        it "Activityのレコード数が変わっていないこと" do
          Activity.count.must_equal @activity_count
        end

        it "activityの内容が更新されていないこと" do
          Activity.find_by(type_id: Activity::type_ids[:reply], reply_id: @reply.id).must_equal @activity
        end
      end
    end
  end
end
