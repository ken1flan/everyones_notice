require "test_helper"

describe "画像の投稿 Integration" do
  describe "画像を投稿する" do
    before do
      @user = login
    end

    context "画像一覧で「新規追加」ボタンを押したとき" do
      context "なにも記入しないで「保存」ボタンを押したとき" do
        it "エラーが出ること" do
        end

        context "正しい情報を入力して「保存」ボタンを押したとき" do
          it "詳細画面に遷移していること" do
          end

          it "一覧画面に表示されていること" do
          end
        end
      end

      context "正しい情報を入力して「保存」ボタンを押したとき" do
        it "詳細画面に遷移していること" do
        end
      end
    end
  end

  describe "アクセス制御" do
    context "ログインしていないとき" do
      context "画像一覧が見れないこと" do
      end

      context "画像詳細が見れないこと" do
      end
    end
  end
end
