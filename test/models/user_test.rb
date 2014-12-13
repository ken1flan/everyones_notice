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

  describe ".activities_for_heatmap" do
    before do
      @user = create(:user)
      Timecop.freeze
    end

    context "noticeがないとき" do
      it "nilであること" do
        @heatmap = @user.activities_for_heatmap
        JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal nil
      end
    end

    context "現在が2014/11/29 09:04:12 のとき" do
      before do
        @now = Time.local(2014, 11, 29, 9, 4, 12)
        Timecop.travel @now
      end

      context "2014/05/31 23:59:59にnoticeが1件あったとき" do
        before do
          @published_at = Time.local(2014, 5, 31, 23, 59, 59)
          create(:notice, user_id: @user.id, published_at: @published_at)
        end

        it "nilであること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal nil
        end
      end

      context "2014/06/01 00:00:00にnoticeが1件あったとき" do
        before do
          @published_at = Time.local(2014, 6, 1, 0, 0, 0)
          create(:notice, user_id: @user.id, published_at: @published_at)
        end

        it "1であること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal 1
        end
      end

      context "2014/11/29 09:04:12にnoticeが1件あったとき" do
        before do
          @published_at = Time.local(2014, 11, 29, 9, 4, 12)
          create(:notice, user_id: @user.id, published_at: @published_at)
        end

        it "1であること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal 1
        end
      end

      context "2014/11/29 09:04:13にnoticeが1件あったとき" do
        before do
          @published_at = Time.local(2014, 11, 29, 9, 4, 13)
          create(:notice, user_id: @user.id, published_at: @published_at)
        end

        it "nilであること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal nil
        end
      end

      context "2014/06/01 00:00:00にnoticeが2件あったとき" do
        before do
          @published_at = Time.local(2014, 6, 1, 0, 0, 0)
          create_list(:notice, 2, user_id: @user.id, published_at: @published_at)
        end
 
        it "2であること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal 2
        end
      end

      context "2014/06/01 00:00:00に他のユーザのnoticeが1件あったとき" do
        before do
          @user_another = create(:user)
          @published_at = Time.local(2014, 6, 1, 0, 0, 0)
          create(:notice, user_id: @user_another.id, published_at: @published_at)
        end
 
        it "nilであること" do
          @heatmap = @user.activities_for_heatmap
          JSON.parse(@heatmap)[@published_at.to_i.to_s].must_equal nil
        end
      end
    end

    after { Timecop.return }
  end
end
