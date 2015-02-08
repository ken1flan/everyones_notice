require "test_helper"

describe "タグ Integration" do
  before { login }

  context "タグがひとつあるとき" do
    before { @tag = create(:tag) }

    context "一覧ページを訪れたとき" do
      before { visit tags_path }

      it "タグ名がないこと" do
        page.html.wont_include @tag.name
      end
    end

    context "きづきが紐付いているとき" do
      before do
        @tagged_notice = create(:notice, tags: [@tag])
        @not_tagged_notice = create(:notice)
      end

      context "詳細ページを訪れたとき" do
        before { visit tag_path(@tag) }

        it "タグ名が表示されていること" do
          page.text.must_include @tag.name
        end

        it "紐付いているきづきが表示されていること" do
          page.text.must_include @tagged_notice.title
          page.text.wont_include @not_tagged_notice.title
        end
      end
    end
  end
end
