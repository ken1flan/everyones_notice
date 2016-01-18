require 'test_helper'

describe 'Liked Concern' do
  before { @target = [:notice, :reply, :advertisement].sample }

  describe '#liked_by / #unliked_by' do
    before do
      @user = create(:user)
      @target_instance = create(@target)
    end

    context '#liked_byを実行したとき' do
      before do
        @target_instance.liked_by(@user)
      end

      it 'approvalsが登録されていること' do
        @target_instance.approvals.count.must_equal 1
      end

      context 'unliked_byを実行したとき' do
        before do
          @target_instance.unliked_by(@user)
        end

        it 'approvalsがdeletedとして登録されていること' do
          @target_instance.approvals.count.must_equal 1
          @target_instance.approvals.where(deleted: true).count.must_equal 1
        end
      end
    end

    context '#unliked_byを実行したとき' do
      before do
        @target_instance.unliked_by(@user)
      end

      it 'approvalsがdeletedとして登録されていること' do
        @target_instance.approvals.count.must_equal 1
        @target_instance.approvals.where(deleted: true).count.must_equal 1
      end

      context '#liked_byを実行したとき' do
        before do
          @target_instance.liked_by(@user)
        end

        it 'approvalsが登録されていること' do
          @target_instance.approvals.count.must_equal 1
        end
      end
    end
  end

  describe '#liked_by?' do
    before do
      @user = create(:user)
      @target_instance = create(@target)
    end

    context 'userがlikeをしていないとき' do
      it 'falseであること' do
        @target_instance.liked_by?(@user).must_equal(false)
      end
    end

    context 'userがlikeをしたとき' do
      before { @target_instance.liked_by(@user) }

      it 'trueであること' do
        @target_instance.liked_by?(@user).must_equal(true)
      end
    end

    context 'userがlikeをしたあと取り消したとき' do
      before do
        @target_instance.liked_by(@user)
        @target_instance.unliked_by(@user)
      end

      it 'falseであること' do
        @target_instance.liked_by?(@user).must_equal(false)
      end
    end
  end

  describe '#like_number' do
    before do
      @users = create_list(:user, 2)
      @target_instance = create(@target)
    end

    context '誰もlikeしてないとき' do
      it '0であること' do
        @target_instance.like_number.must_equal(0)
      end
    end

    context 'likeしたが、取り消したひとがいるとき' do
      before do
        @target_instance.approvals.create(user: @users[0])
        @target_instance.approvals.find_by(user: @users[0]).update_attributes(deleted: true)
      end

      it '0であること' do
        @target_instance.like_number.must_equal(0)
      end
    end

    context 'likeしたひとが1人いるとき' do
      before do
        @target_instance.approvals.create(user: @users[0])
      end

      it '1であること' do
        @target_instance.like_number.must_equal(1)
      end
    end

    context 'likeしたひとが2人いるとき' do
      before do
        @target_instance.approvals.create(user: @users[0])
        @target_instance.approvals.create(user: @users[1])
      end

      it '1であること' do
        @target_instance.like_number.must_equal(2)
      end
    end
  end
end
