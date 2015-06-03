require "test_helper"

describe "Liked Concern" do
  before { @target = [:notice, :reply, :advertisement].sample }

  describe "#liked_by / #unliked_by" do
    before do
      @user = create(:user)
      @target_instance = create(@target)
    end

    context "#liked_byを実行したとき" do
      before do
        @target_instance.liked_by(@user)
      end

      it "approvalsが登録されていること" do
        @target_instance.approvals.count.must_equal 1
      end

      it "evaluation.valueが1であること" do
        evaluation = get_evaluation(@target_instance, @user)
        evaluation.value.must_equal 1
      end

      context "unliked_byを実行したとき" do
        before do
          @target_instance.unliked_by(@user)
        end
  
        it "approvalsがdeletedとして登録されていること" do
          @target_instance.approvals.count.must_equal 1
          @target_instance.approvals.where(deleted: true).count.must_equal 1
        end
  
        it "evaluation.valueが1であること" do
          evaluation = get_evaluation(@target_instance, @user)
          evaluation.value.must_equal 0
        end
      end
    end

    context "#unliked_byを実行したとき" do
      before do
        @target_instance.unliked_by(@user)
      end

      it "approvalsがdeletedとして登録されていること" do
        @target_instance.approvals.count.must_equal 1
        @target_instance.approvals.where(deleted: true).count.must_equal 1
      end

      it "evaluation.valueが1であること" do
        evaluation = get_evaluation(@target_instance, @user)
        evaluation.value.must_equal 0
      end

      context "#liked_byを実行したとき" do
        before do
          @target_instance.liked_by(@user)
        end
  
        it "approvalsが登録されていること" do
          @target_instance.approvals.count.must_equal 1
        end
  
        it "evaluation.valueが1であること" do
          evaluation = get_evaluation(@target_instance, @user)
          evaluation.value.must_equal 1
        end
      end
    end


    def get_evaluation(target_instance, user)
      target_instance.
        evaluations.
        where(reputation_name: :likes, source_id: user.id).
        first
    end
  end

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
        ret.must_equal @target_instance.like_number2
      end
    end

    context "likeしたが、取り消したひとがいるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
        @target_instance.add_or_update_evaluation(:likes, 0, @users[0])
        @target_instance.approvals.create(user: @users[0])
        @target_instance.approvals.find_by(user: @users[0]).update_attributes(deleted: true)
      end

      it "0であること" do
        ret = @target_instance.like_number
        ret.must_equal(0)
        ret.must_equal @target_instance.like_number2
      end
    end

    context "likeしたひとが1人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
        @target_instance.approvals.create(user: @users[0])
      end

      it "1であること" do
        ret = @target_instance.like_number
        ret.must_equal(1)
        ret.must_equal @target_instance.like_number2
      end
    end

    context "likeしたひとが2人いるとき" do
      before do
        @target_instance.add_or_update_evaluation(:likes, 1, @users[0])
        @target_instance.approvals.create(user: @users[0])
        @target_instance.add_or_update_evaluation(:likes, 1, @users[1])
        @target_instance.approvals.create(user: @users[1])
      end

      it "1であること" do
        ret = @target_instance.like_number
        ret.must_equal(2)
        ret.must_equal @target_instance.like_number2
      end
    end
  end
end
