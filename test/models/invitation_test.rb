require 'test_helper'

describe Invitation do
  before { Timecop.freeze }
  after { Timecop.return }

  describe "#generate_token" do
    context "実行したとき" do
      before do
        @invitation = build(:invitation)
        @invitation.generate_token
      end

      it "tokenが設定されていること" do
        @invitation.present?.must_equal true
      end

      it "expired_atが#{Invitation::EXPIRATION_PERIOD.since}に設定されていること" do
        @invitation.expired_at.must_equal Invitation::EXPIRATION_PERIOD.since
      end
    end
  end

  describe "#expired?" do
    context "#{Time.zone.now}の招待のとき" do
      before do
        @invitation = create( :invitation )
        @invitation.update_attributes expired_at:Time.zone.now
      end

      it "falseであること" do
        @invitation.expired?.must_equal false
      end
    end

    context "#{Time.zone.now - 1.second}の招待のとき" do
      before do
        @invitation = create( :invitation )
        @invitation.update_attributes expired_at: (Time.zone.now - 1.second)
      end

      it "trueであること" do
        @invitation.expired?.must_equal true
      end
    end
  end

  describe "#user_registered?" do
    context "user_id = nilのとき" do
      before do
        @invitation = create( :invitation, user_id: nil )
      end

      it "falseであること" do
        @invitation.user_registered?.must_equal false
      end
    end

    context "user_id = 1のとき" do
      before do
        @invitation = create( :invitation, user_id: 1 )
      end

      it "trueであること" do
        @invitation.user_registered?.must_equal true
      end
    end
  end

  describe ".invalid_token? / .valid_token?" do
    before do
      @token = "testtoken"
    end

    context "Invitationが1件もないとき" do
      it ".invalid_token? = true / .valid_token? = falseであること" do
        Invitation.invalid_token?(@token).must_equal true
        Invitation.valid_token?(@token).must_equal   false
      end
    end

    context "指定されたtokenのInvitationがないとき" do
      before do
        create_list(:invitation, 10)
      end

      it ".invalid_token? = true / .valid_token? = falseであること" do
        Invitation.invalid_token?(@token).must_equal true
        Invitation.valid_token?(@token).must_equal   false
      end
    end


    context "指定されたtokenのInvitationがexpired_at = 昨日のとき" do
      before do
        @invitation = create(:invitation)
        @invitation.update_attributes(expired_at: 1.day.ago)
      end

      it ".invalid_token? = true / .valid_token? = falseであること" do
        Invitation.invalid_token?(@invitation.token).must_equal true
        Invitation.valid_token?(@invitation.token).must_equal   false
      end
    end

    context "指定されたtokenのInvitationがuser_id = 1のとき" do
      before do
        @invitation = create(:invitation, user_id: 1)
      end

      it ".invalid_token? = true / .valid_token? = falseであること" do
        Invitation.invalid_token?(@invitation.token).must_equal true
        Invitation.valid_token?(@invitation.token).must_equal   false
      end
    end

    context "指定されたtokenのInvitationがuser_id = nil, expired_at = 明日のとき" do
      before do
        @invitation = create(:invitation, user_id: nil)
        @invitation.update_attributes(expired_at: 1.day.since)
      end

      it ".invalid_token? = false / .valid_token? = trueであること" do
        Invitation.invalid_token?(@invitation.token).must_equal false
        Invitation.valid_token?(@invitation.token).must_equal   true
      end
    end
  end

end
