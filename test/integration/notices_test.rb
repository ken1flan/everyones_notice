require "test_helper"

describe "きづき Integration" do
  describe "新規作成" do
    context "ログインしているとき" do
      before do
        @user = create_user_and_identity("twitter")
        login @user
      end

      context "新規作成ページを訪れたとき" do
        before { visit new_notice_path }

        context "タイトルと本文を入力して公開を押したとき" do
          before do
            @notice_org = build :notice
            fill_in "notice_title", with: @notice_org.title
            fill_in "notice_body", with: @notice_org.body
            click_button "公開"
          end

          context "一覧を訪れたとき" do
            before { visit notices_path }

            it "表示されていること" do
              notice_list = find("#notice_list").text
              notice_list.must_include @notice_org.title
              notice_list.must_include @user.nickname
            end
          end
        end
      end
    end
  end

  describe "編集" do
    context "ログインしているとき" do
      before do
        @user = create_user_and_identity("twitter")
        login @user
      end

      context "自分のきづきがあるとき" do
        before { @notice_org = create :notice, user: @user }

        context "編集画面に訪れたとき" do
          before { visit edit_notice_path(@notice_org) }

          context "内容を変更して、公開を押したとき" do
            before do
              @notice_new = build(:notice)
              fill_in "notice_title", with: @notice_new.title
              fill_in "notice_body", with: @notice_new.body
              click_button "公開"
            end

            context "一覧画面を訪れたとき" do
              before { visit notices_path }

              it "変更した内容が反映されていること" do
                notice_list = find("#notice_list").text
                notice_list.must_include @notice_new.title
                notice_list.must_include @user.nickname
              end
            end

            context "詳細画面を訪れたとき" do
              before { visit notice_path(@notice_org) }

              it "変更した内容が反映されていること" do
                page.text.must_include @notice_new.title
                page.text.must_include @notice_new.body
              end
            end
          end
        end
      end

      context "他のひとのきづきがあるとき" do
        before do
          user_anoter = create :user
          @notice_anoter_user = create :notice, user: user_anoter
        end

        context "編集画面を訪れたとき" do
          before { visit edit_notice_path(@notice_anoter_user) }

          it "404 not foundであること" do
            page.status_code.must_equal 404
          end
        end
      end
    end
  end

  def must_include_title_and_body(text, notice, user)
    text.must_include notice.title
    text.must_include user.nickname
  end
end
