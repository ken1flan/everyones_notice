require "test_helper"

describe "フィードバック Integration" do
  describe "フィードバックを書く" do
    before { @user = login }

    context "トップでfeedbackボタンを押したとき" do
      before do
        visit root_path
        click_button "feedback_button"
      end

      context "なにも書かないで送信ボタンを押したとき" do
        before do
          click_button "送る"
          sleep 2
        end

        it "エラーが表示されること" do
          page.text.must_include "を入力してください"
        end
      end

      context "内容を書いて送信ボタンを押したとき" do
        before do
          fill_in "feedback_body", with: "テストテスト"
          click_button "送る"
          sleep 2
        end

        it "謝辞が表示されること" do
          page.text.must_include "ありがとうございました"
        end
      end
    end
  end
end
