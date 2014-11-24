require "test_helper"

describe "Liked Concern" do
  before { @target = [:notice, :reply].sample }

  describe "#liked_by?" do
    before do
      @user = create(:user)
      @target_instance = create(@target)
    end

    context "userがlikeをしていないとき" do
      it "falseであること" do
        ret = @target_instance.liked_by?(@user)
        ret.must_equal(false)
      end
    end

    context "userがlikeをしたとき" do
      before { @target_instance.add_or_update_evaluation(:likes, 1, @user) }

      it "trueであること" do
        ret = @target_instance.liked_by?(@user)
        ret.must_equal(true)
      end
    end

    context "userがlikeをしたあと取り消したとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @user)
        @target_instance.add_or_update_evaluation(:likes, 0, @user)
      end

      it "falseであること" do
        ret = @target_instance.liked_by?(@user)
        ret.must_equal(false)
      end
    end
  end

  describe "#like_number" do
    before do
      @users = create_list(:user, 2)
      @target_instance = create(@target)
    end

    context "誰もlikeしてないとき" do
      it "0であること" do
        ret = @target_instance.like_number
        ret.must_equal(0)
      end
    end

    context "likeしたが、取り消したひとがいるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
        @target_instance.add_or_update_evaluation(:likes, 0, @users[0])
      end

      it "0であること" do
        ret = @target_instance.like_number
        ret.must_equal(0)
      end
    end

    context "likeしたひとが1人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
      end

      it "1であること" do
        ret = @target_instance.like_number
        ret.must_equal(1)
      end
    end

    context "likeしたひとが2人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
        @target_instance.add_or_update_evaluation(:likes, 1, @users[1])
      end

      it "1であること" do
        ret = @target_instance.like_number
        ret.must_equal(2)
      end
    end
  end
end
