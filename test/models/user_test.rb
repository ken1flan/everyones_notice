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
end
