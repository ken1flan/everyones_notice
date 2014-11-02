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
end
