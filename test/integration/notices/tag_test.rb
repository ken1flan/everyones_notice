require "test_helper"

describe "きづきのタグ Integration" do
  before do
    @user = login
    @notice = create(:notice)
  end

  context "きづき詳細を訪れたとき" do
    before { visit notice_path(@notice) }

    context "タグの追加ボタンを押したとき" do
      before { click_button "add_tag_button_#{@notice.id}" }

      context "タグ名を入れないで保存したとき" do
        before do
          click_button "submit_notice_tag_button_#{@notice.id}"
          sleep 1 # 更新に時間がかかるため
        end

        it "エラーが表示されること" do
          page.text.must_include "タグ名を入力してください"
        end
      end

      context "今まで登録されていないタグ名を入れて保存したとき" do
        before do
          fill_in "notice_tag_name_#{@notice.id}", with: "タグ1"
          click_button "submit_notice_tag_button_#{@notice.id}"
          sleep 1 # 更新に時間がかかるため
        end

        it "タグ名が表示されていること" do
          page.text.must_include "タグ1"
        end

        context "タグ一覧ページを訪れたとき" do
          before { visit tags_path }

          it "タグ名が表示されていること" do
            page.text.must_include "タグ1"
          end
        end
      end

      context "すでに登録されているタグ名を入れて保存したとき" do
        before do
          @tag = create(:tag)
          @tags_count = Tag.count
          fill_in "notice_tag_name_#{@notice.id}", with: @tag.name
          click_button "submit_notice_tag_button_#{@notice.id}"
          sleep 1 # 更新に時間がかかるため
        end

        it "タグ名が表示されていること" do
          page.text.must_include @tag.name
        end

        it "タグ数は増えていないこと" do
          Tag.count.must_equal @tags_count
        end
      end
    end
  end
end
