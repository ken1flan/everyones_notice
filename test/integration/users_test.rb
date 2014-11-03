require "test_helper"

describe "ユーザ管理 Integration" do
  describe "ユーザの新規作成" do
    context "トークンなしでユーザ作成ページへ訪れたとき" do
      before { visit new_user_path }

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "期限の切れたトークンでユーザ作成ページへ訪れたとき" do
      before do
        invitation = create( :invitation )
        invitation.update_attributes(expired_at: 1.day.ago)
        visit new_user_path( token: invitation.token )
      end

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "ユーザ登録の済んだトークンでユーザ作成ページへ訪れたとき" do
      before do
        invitation = create( :user_registered_invitation )
        visit new_user_path( token: invitation.token )
      end

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "正しいトークンでユーザ作成ページを訪れたとき" do
      before do
        invitation = create( :invitation )
        visit new_user_path( token: invitation.token )
      end

      it "200 OKであること" do
        page.status_code.must_equal 200
      end
    end
  end
end
