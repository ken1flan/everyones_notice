require "test_helper"

describe "画像の投稿 Integration" do
  describe "画像を投稿する" do
    before do
      @user = login
    end

    context "画像一覧で「新規追加」ボタンを押したとき" do
      before do
        visit post_images_path
        click_link "新規作成"
      end

      context "なにも記入しないで「保存」ボタンを押したとき" do
        before do
          click_button "登録する"
        end

        it "エラーが出ること" do
          page.text.must_include "を入力してください"
        end

        context "正しい情報を入力して「保存」ボタンを押したとき" do
          before do
            fill_in "post_image_title", with: "画像のタイトル"
            attach_file "post_image_image", Rails.root.join("test", "fixtures", "images", "テスト画像.jpg")
            click_button "登録する"
          end

          it "一覧画面に表示されていること" do
            page.text.must_include "画像のタイトル"
            page.html.must_include "_____.jpg"
          end
        end
      end

      context "正しい情報を入力して「保存」ボタンを押したとき" do
        before do
          fill_in "post_image_title", with: "画像のタイトル"
          attach_file "post_image_image", Rails.root.join("test", "fixtures", "images", "テスト画像.jpg")
          click_button "登録する"
        end

        it "一覧画面に表示されていること" do
          page.text.must_include "画像のタイトル"
          page.html.must_include "_____.jpg"
        end
      end
    end
  end

  describe "アクセス制御" do
    before { @post_image = create(:post_image) }

    context "ログインしていないとき" do
      context "画像一覧を訪れたとき" do
        before { visit post_images_path }

        it "ログインページであること" do
          current_path.must_equal login_path
        end
      end

      context "画像詳細が見れないこと" do
        before { visit post_image_path(@post_image) }

        it "ログインページであること" do
          current_path.must_equal login_path
        end
      end
    end
  end
end
