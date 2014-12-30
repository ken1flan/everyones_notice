# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)
#  club_id    :integer          default(1), not null
#  admin      :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#  icon_url   :string(255)
#
# Indexes
#
#  index_users_on_club_id  (club_id)
#

require 'test_helper'

describe User do
  describe ".create_with_identity" do
    before do
      @auth = {
        provider: :test_provider,
        uid: "#{ rand(10000) }",
        info: { nickname: "nickname_#{rand(10000)}" }
      }
    end

    context "tokenに該当するinvitationがみつからないとき" do
      it "例外になること" do
        token = "testtoken"
        proc { User.create_with_identity( @auth, token ) }.
          must_raise(ActiveRecord::RecordNotFound)
      end
    end

    context "tokenに該当するinvitationが存在するとき" do
      before do
        @invitation = create(:invitation)
      end

      it "User、Identityが作成され、Invitationのuser_idがセットされていること" do
        user = User.create_with_identity( @auth, @invitation.token )
        user.nickname.must_equal @auth[:info][:nickname]
        identity = user.identities.first
        identity.provider.must_equal @auth[:provider].to_s
        identity.uid.must_equal @auth[:uid]

        invitation = Invitation.find( @invitation.id )
        invitation.user_id.must_equal user.id
      end
    end
  end

  describe ".find_from" do
    before do
      @user = create( :user )
      @identity = create( :identity, user_id: @user.id )
      @auth = {
        provider: :test_provider,
        uid: "#{ rand(10000) }",
        info: { nickname: "nickname_#{rand(10000)}" }
      }
    end

    context "auth[:provider]が異なるとき" do
      it "例外が起きること" do
        auth = @auth.dup
        auth[:provider] = "wrong_provider"
        proc { User.find_from( auth ) }.
          must_raise(ActiveRecord::RecordNotFound)
      end
    end

    context "auth[:uid]が異なるとき" do
      it "例外が起きること" do
        auth = @auth.dup
        auth[:uid] = "wrong_uid"
        proc { User.find_from( auth ) }.
          must_raise(ActiveRecord::RecordNotFound)
      end
    end

    context "auth[:provider]、auth[:uid]が同じとき" do
      it "例外が起きること" do
        proc { User.find_from( @auth ) }.
          must_raise(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#read_notices / #unread_notices" do
    before { @user = create(:user) }

    context "きづきがないとき" do
      it "#read_noticesが0件であること" do
        @user.read_notices.count.must_equal 0
      end

      it "#unread_noticesが0件であること" do
        @user.unread_notices.count.must_equal 0
      end
    end

    context "きづきが1件のとき" do
      before { @notice = create(:notice) }

      it "#read_noticesが0件であること" do
        @user.read_notices.count.must_equal 0
      end

      it "#unread_noticesが1件であること" do
        @user.unread_notices.count.must_equal 1
        @user.unread_notices.first.must_equal @notice
      end
    end

    context "読まれたきづきが1件のとき" do
      before do
        @notice = create(:notice)
        @notice.read_by @user
      end

      it "#read_noticesが1件であること" do
        @user.read_notices.count.must_equal 1
        @user.read_notices.first.must_equal @notice
      end

      it "#unread_noticesが1件であること" do
        @user.unread_notices.count.must_equal 0
      end
    end

    context "ほかのひとに読まれたきづきが1件のとき" do
      before do
        @another_user = create(:user)
        @notice = create(:notice)
        @notice.read_by @another_user
      end

      it "#read_noticesが1件であること" do
        @user.read_notices.count.must_equal 0
      end

      it "#unread_noticesが1件であること" do
        @user.unread_notices.count.must_equal 1
        @user.unread_notices.first.must_equal @notice
      end
    end

    context "読んだきづきと読んでいないものが1件ずつあるとき" do
      before do
        @unread_notice = create(:notice)
        @read_notice = create(:notice)
        @read_notice.read_by @user
      end

      it "#read_noticesが1件であること" do
        @user.read_notices.count.must_equal 1
        @user.read_notices.first.must_equal @read_notice
      end

      it "#unread_noticesが1件であること" do
        @user.unread_notices.count.must_equal 1
        @user.unread_notices.first.must_equal @unread_notice
      end

    end
  end

  describe "#activities_for_heatmap" do
    before do
      @user = create(:user)
      Timecop.freeze
    end

    [:notice, :reply].each do |activity_type|
      context "noticeがないとき" do
        it "nilであること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
        end
      end

      context "現在が2014/11/29 09:04:12 のとき" do
        before do
          @now = Time.local(2014, 11, 29, 9, 4, 12)
          Timecop.travel @now
        end

        context "2014/05/31 23:59:59に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 5, 31, 23, 59, 59)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "nilであること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end

        context "2014/06/01 00:00:00に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "1であること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 1
          end
        end

        context "2014/11/29 09:04:12に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 11, 29, 9, 4, 12)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "1であること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 1
          end
        end

        context "2014/11/29 09:04:13に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 11, 29, 9, 4, 13)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "nilであること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end

        context "2014/06/01 00:00:00に#{activity_type}が2件あったとき" do
          before do
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            create_list(:activity, 2, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end
 
          it "2であること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 2
          end
        end

        context "2014/06/01 00:00:00に他のユーザの#{activity_type}が1件あったとき" do
          before do
            @user_another = create(:user)
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user_another.id, created_at: @created_at)
          end
 
          it "nilであること" do
            @heatmap = @user.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end
      end
    end

    after { Timecop.return }
  end
end
