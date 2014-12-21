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
  describe "#read_by" do
    before do
      @notice = create(:notice)
      @user = create(:user)
    end

    context "ユーザを指定して#read_byを実行したとき" do
      before { @notice.read_by @user }

      it "NoticeReadUserに指定したユーザとそのnoticeが追加されること" do
        NoticeReadUser.count.must_equal 1
        notice_read_user = NoticeReadUser.first
        notice_read_user.notice_id.must_equal @notice.id
        notice_read_user.user_id.must_equal @user.id
      end

      context "もう一度同じユーザを指定して#read_byを実行したとき" do
        before { @notice.read_by @user }

        it "NoticeReadUserの件数は1であること" do
          NoticeReadUser.count.must_equal 1
        end
      end

      context "ほかのユーザを指定して#read_byを実行したとき" do
        before do
          @another_user = create(:user)
          @notice.read_by @another_user
        end

        it "NoticeReadUserが2件になること" do
          NoticeReadUser.count.must_equal 2
        end
      end

      context "#read_byしたユーザを指定して#unread_byを実行したとき" do
        before { @notice.unread_by @user }

        it "NoticeReadUserが空になること" do
          NoticeReadUser.count.must_equal 0
        end
      end
    end
  end

  describe "#unread_by" do
    before do
      @notice = create(:notice)
      @user = create(:user)
    end

    context "#unread_byしたとき" do
      it "NoticeReadUserが0件であること" do
        NoticeReadUser.count.must_equal 0
      end
    end

    context "noticeが#read_byされたとき" do
      before { @notice.read_by @user }

      it "NoticeReadUserが1件になること" do
        NoticeReadUser.count.must_equal 1
      end

      context "#unread_byしたとき" do
        before { @notice.unread_by @user }

        it "NoticeReadUserが0件になること" do
          NoticeReadUser.count.must_equal 0
        end
      end
    end

    context "noticeが他のユーザにread_byされたとき" do
      before do
        @another_user = create(:user)
        @notice.read_by @another_user
      end

      it "NoticeReadUserが1件になること" do
        NoticeReadUser.count.must_equal 1
      end

      context "#unread_byを実行したとき" do
        before { @notice.unread_by @user }

        it "NoticeReadUserが1件になること" do
          NoticeReadUser.count.must_equal 1
        end
      end
    end
  end

  describe "#read_by?" do
    before do
      @user = create(:user)
      @notice = create(:notice)
    end

    context "userが#read_byしていないとき" do
      it "falseであること" do
        ret = @notice.read_by?(@user)
        ret.must_equal(false)
      end
    end

    context "userが#read_byしたとき" do
      before { @notice.read_by @user }

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

    context "誰も#read_byしてないとき" do
      it "0であること" do
        ret = @notice.read_user_number
        ret.must_equal(0)
      end
    end

    context "#read_byしたひとが1人いるとき" do
      before do
        @notice.read_by @users[0]
      end

      it "1であること" do
        ret = @notice.read_user_number
        ret.must_equal(1)
      end
    end

    context "#read_byしたひとが2人いるとき" do
      before do
        @notice.read_by @users[0]
        @notice.read_by @users[1]
      end

      it "1であること" do
        ret = @notice.read_user_number
        ret.must_equal(2)
      end
    end
  end

  describe "#read_users / #unread_users" do
    before do
      @notice = create(:notice)
      @users = [@notice.user]
    end

    context "ほかにユーザが二人いたとき" do
      before { @users += create_list(:user, 2) }

      it ".read_usersが空であること" do
        @notice.read_users.blank?.must_equal true
      end

      it ".unread_usersがユーザが全員いること" do
        unread_users = @notice.unread_users
        unread_users.include?(@notice.user).must_equal true
        @users.each do |user|
          unread_users.include?(user).must_equal true
        end
      end

      context "いずれかのユーザが読んだとき" do
        before do
          @read_user = @users.sample
          @notice.read_by @read_user
          @unread_users = @users.reject {|user| user == @read_user }
        end

        it ".read_usersに読んだユーザがいること" do
          @notice.read_users.include?(@read_user).must_equal true
          @unread_users.each do |user|
            @notice.read_users.include?(user).must_equal false
          end
        end

        it ".unread_usersに読んだユーザがいないこと" do
          @notice.unread_users.include?(@read_user).must_equal false
          @unread_users.each do |user|
            @notice.unread_users.include?(user).must_equal true
          end
        end

        context "読んだユーザが読まなかったことにしたとき" do
          before { @notice.unread_by @read_user }

          it ".read_usersが空であること" do
            @notice.read_users.blank?.must_equal true
          end
    
          it ".unread_usersがユーザが全員いること" do
            unread_users = @notice.unread_users
            unread_users.include?(@notice.user).must_equal true
            @users.each do |user|
              unread_users.include?(user).must_equal true
            end
          end
        end
      end
    end
  end

  describe "#register_activity" do
    context "noticeを公開状態でcreateしたとき" do
      before do
        @notice = create(:notice)
        @activity_count = Activity.count
        @activity = Activity.find_by(type_id: Activity::type_ids[:notice], notice_id: @notice.id)
      end

      it "Activityにユーザが登録されていること" do
        @activity.user_id.must_equal @notice.user_id
      end

      context "noticeを更新したとき" do
        before { @notice.update_attributes(title: "更新タイトル", body: "更新内容") }

        it "Activityのレコード数が変わっていないこと" do
          Activity.count.must_equal @activity_count
        end

        it "activityの内容が更新されていないこと" do
          Activity.find_by(type_id: Activity::type_ids[:notice], notice_id: @notice.id).must_equal @activity
        end
      end
    end

    context "noticeを下書き状態でcreateしたとき" do
      before do
        @notice = create(:notice, :draft)
        @activity_count = Activity.count
        @activity = Activity.find_by(type_id: Activity::type_ids[:notice], notice_id: @notice.id)
      end

      it "Activityのレコード数が変わっていないこと" do
        Activity.count.must_equal @activity_count
      end

      context "noticeを更新したとき" do
        before { @notice.update_attributes(title: "更新タイトル", body: "更新内容") }

        it "Activityのレコード数が変わっていないこと" do
          Activity.count.must_equal @activity_count
        end
      end

      context "noticeを公開として更新したとき" do
        before do
          @notice.update_attributes(title: "更新タイトル", body: "更新内容", published_at: Time.zone.now)
          @activity = Activity.find_by(type_id: Activity::type_ids[:notice], notice_id: @notice.id)
        end

        it "Activityにユーザが登録されていること" do
          @activity.user_id.must_equal @notice.user_id
        end
      end
    end
  end
end
