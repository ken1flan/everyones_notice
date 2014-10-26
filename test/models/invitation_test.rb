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

      it "expired_atが#{Invitation::EXPIRATION_PERIOD.ago}に設定されていること" do
        @invitation.expired_at.must_equal Invitation::EXPIRATION_PERIOD.ago
      end
    end
  end
end
