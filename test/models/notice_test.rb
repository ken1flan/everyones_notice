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

require 'test_helper'

describe Notice do
  describe "#read_by?" do
    before do
      @user = create(:user)
      @notice = create(:notice)
    end

    context "userがopenしていないとき" do
      it "falseであること" do
        ret = @notice.read_by?(@user)
        ret.must_equal(false)
      end
    end

    context "userがopenしたとき" do
      before { @notice.read_users << @user }

      it "trueであること" do
        ret = @notice.read_by?(@user)
        ret.must_equal(true)
      end
    end
  end

  describe "#read_user_number" do
    before do
      @users = create_list(:user, 2)
      @notice = create(:notice)
    end

    context "誰もlikeしてないとき" do
      it "0であること" do
        ret = @notice.read_user_number
        ret.must_equal(0)
      end
    end

    context "openしたひとが1人いるとき" do
      before do
        @notice.read_users << @users[0]
      end

      it "1であること" do
        ret = @notice.read_user_number
        ret.must_equal(1)
      end
    end

    context "openしたひとが2人いるとき" do
      before do
        @notice.read_users << @users[0]
        @notice.read_users << @users[1]
      end

      it "1であること" do
        ret = @notice.read_user_number
        ret.must_equal(2)
      end
    end
  end
end
