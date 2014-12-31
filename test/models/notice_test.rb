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

  describe ".weekly_watched" do
    before do
      Timecop.freeze
      Notice.skip_callback(:save, :after, :register_activity)
      Reply.skip_callback(:save, :after, :register_activity)
    end
      
    describe "選択について" do
      context "7日+1秒前のactivity(notice)のあるnoticeがあるとき" do
        before do
          @notice = create(:notice)
          @activity = create(
            :activity,
            notice: @notice,
            type_id: Activity::type_ids[:notice],
            created_at: (7.days.ago - 1))
        end

        it "空であること" do
          Notice.weekly_watched.blank?.must_equal true
        end
      end

      context "7日前のactivity(notice)のあるnoticeがあるとき" do
        before do
          @notice = create(:notice)
          @activity = create(
            :activity,
            notice: @notice,
            type_id: Activity::type_ids[:notice],
            created_at: 7.days.ago)
        end

        it "activityのnoticeが1件含まれていること" do
          result = Notice.weekly_watched
          result.to_a.count.must_equal 1
          result.first.must_equal @activity.notice
        end
      end

      context "7日+1秒前のactivity(thumbup_notice)のあるnoticeがあるとき" do
        before do
          @notice = create(:notice)
          @activity = create(
            :activity,
            notice: @notice,
            type_id: Activity::type_ids[:thumbup_notice],
            created_at: (7.days.ago - 1))
        end

        it "空であること" do
          Notice.weekly_watched.blank?.must_equal true
        end
      end

      context "7日前のactivity(thumbup_notice)のあるnoticeがあるとき" do
        before do
          @notice = create(:notice)
          @activity = create(
            :activity,
            notice: @notice,
            type_id: Activity::type_ids[:thumbup_notice],
            created_at: 7.days.ago)
        end

        it "activityのnoticeが1件含まれていること" do
          result = Notice.weekly_watched
          result.to_a.count.must_equal 1
          result.first.must_equal @activity.notice
        end
      end

      context "7日+1秒前のactivity(reply)のあるnoticeがあるとき" do
        before do
          @reply = create(:reply)
          @activity = create(
            :activity,
            notice: @reply.notice,
            reply: @reply,
            type_id: Activity::type_ids[:reply],
            created_at: (7.days.ago - 1))
        end

        it "空であること" do
          Notice.weekly_watched.blank?.must_equal true
        end
      end

      context "7日前のactivity(reply)のあるnoticeがあるとき" do
        before do
          @reply = create(:reply)
          @activity = create(
            :activity,
            notice: @reply.notice,
            reply: @reply,
            type_id: Activity::type_ids[:reply],
            created_at: 7.days.ago)
        end

        it "activityのnoticeが1件含まれていること" do
          result = Notice.weekly_watched
          result.to_a.count.must_equal 1
          result.first.must_equal @activity.notice
        end
      end

      context "7日+1秒前のactivity(thumbup_reply)のあるnoticeがあるとき" do
        before do
          @reply = create(:reply)
          @activity = create(
            :activity,
            notice: @reply.notice,
            reply: @reply,
            type_id: Activity::type_ids[:thumbup_reply],
            created_at: (7.days.ago - 1))
        end

        it "空であること" do
          Notice.weekly_watched.blank?.must_equal true
        end
      end

      context "7日前のactivity(thumbup_reply)のあるnoticeがあるとき" do
        before do
          @reply = create(:reply)
          @activity = create(
            :activity,
            notice: @reply.notice,
            reply: @reply,
            type_id: Activity::type_ids[:thumbup_reply],
            created_at: 7.days.ago)
        end

        it "activityのnoticeが1件含まれていること" do
          result = Notice.weekly_watched
          result.to_a.count.must_equal 1
          result.first.must_equal @activity.notice
        end
      end
    end

    describe "順序について" do
      context "4〜1activityのついたnoticeがそれぞれあるとき" do
        before do
          @notices = create_list(:notice, 4)
          @notices.each_with_index do |notice, i|
            (i + 1).times do
              create(
                :activity,
                notice: notice,
                type_id: Activity::type_ids[:thumbup_notice]
              )
            end
          end
        end

        it "4〜1activityのnoticeが順に入っていること" do
          result = Notice.weekly_watched.to_a
          result.count.must_equal 4
          result[0].must_equal @notices[3]
          result[1].must_equal @notices[2]
          result[2].must_equal @notices[1]
          result[3].must_equal @notices[0]
        end
      end
    end

    after do
      Timecop.return
      Notice.set_callback(:save, :after, :register_activity)
      Reply.set_callback(:save, :after, :register_activity)
    end
  end
end
