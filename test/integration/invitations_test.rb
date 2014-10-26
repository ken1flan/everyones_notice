require "test_helper"

describe "ユーザを招待する Integration" do
  context "招待一覧ページを訪れたとき" do
    before do
      @invitation = create(:invitation)
      visit invitations_path
    end

    it "「招待の一覧」と表示されていること" do
      page.text.must_include "招待の一覧"
    end

    context "新規作成を押したとき" do
      before { click_link "新規作成" }

      it "「招待の新規作成」と表示されていること" do
        page.text.must_include "招待の新規作成"
      end
    end

    context "「削除」を押したとき" do
      before { click_link "delete_#{@invitation.id}" }

      it "削除した招待のメールアドレスが表示されていないこと" do
        page.text.wont_include @invitation.mail_address
      end
    end
  end

  context "招待の新規作成ページを訪れたとき" do
    before { visit new_invitation_path }

    it "「招待の新規作成」と表示されていること" do
      page.text.must_include "招待の新規作成"
    end

    context "正しい値を入力して、「送信」を押したとき" do
      before do
        @invitation = build :invitation
        fill_in "invitation_mail_address", with: @invitation.mail_address
        fill_in "invitation_message", with: @invitation.message
        click_button "送信"
      end

      it "入力値が表示されていること" do
        page.text.must_include @invitation.mail_address
        page.text.must_include @invitation.message
      end

      context "「一覧」ボタンを押したとき" do
        before { click_link "一覧" }

        it "メールアドレスが表示されていること" do
          page.text.must_include @invitation.mail_address
        end
      end
    end
  end
end
