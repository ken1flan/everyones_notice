require "test_helper"

describe "ユーザを招待する Integration" do
  context "招待作成ページを訪れたとき" do
    before { visit new_invitation_path }
    it "Invitation Newと表示されていること" do
      page.text.must_include "Invitation New"
    end
  end
end
