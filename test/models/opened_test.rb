require "test_helper"

describe "Opened Concern" do
  before { @target = [:notice].sample }

  describe "#opened_by?" do
    before do
      @user = create(:user)
      @target_instance = create(@target)
    end

    context "userがopenしていないとき" do
      it "falseであること" do
        ret = @target_instance.opened_by?(@user)
        ret.must_equal(false)
      end
    end

    context "userがopenしたとき" do
      before { @target_instance.add_or_update_evaluation(:opened, 1, @user) }

      it "trueであること" do
        ret = @target_instance.opened_by?(@user)
        ret.must_equal(true)
      end
    end

    context "userがopenしたあと取り消したとき" do
      before do
        @target_instance.add_or_update_evaluation(:opened, 1, @user)
        @target_instance.add_or_update_evaluation(:opened, 0, @user)
      end

      it "falseであること" do
        ret = @target_instance.opened_by?(@user)
        ret.must_equal(false)
      end
    end
  end

  describe "#open_number" do
    before do
      @users = create_list(:user, 2)
      @target_instance = create(@target)
    end

    context "誰もlikeしてないとき" do
      it "0であること" do
        ret = @target_instance.open_number
        ret.must_equal(0)
      end
    end

    context "openしたが、取り消したひとがいるとき" do
      before do
        @target_instance.add_or_update_evaluation(:opened, 1, @users[0])
        @target_instance.add_or_update_evaluation(:opened, 0, @users[0])
      end

      it "0であること" do
        ret = @target_instance.open_number
        ret.must_equal(0)
      end
    end

    context "openしたひとが1人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:opened, 1, @users[0])
      end

      it "1であること" do
        ret = @target_instance.open_number
        ret.must_equal(1)
      end
    end

    context "openしたひとが2人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:opened, 1, @users[0])
        @target_instance.add_or_update_evaluation(:opened, 1, @users[1])
      end

      it "1であること" do
        ret = @target_instance.open_number
        ret.must_equal(2)
      end
    end
  end
end
