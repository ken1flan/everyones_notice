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
end
