require "test_helper"

describe "返信 Integration" do
  describe "新規作成" do
    context "ログインしているとき" do
      before do
        @user = login
      end

      context "存在しないきづきの返信新規作成ページを訪れたとき" do
        before { visit new_notice_reply_path(notice_id: 99999) }

        it "404 not foundであること" do
          page.status_code.must_equal 404
        end
      end

      context "きづきがあるとき" do
        before { @notice = create(:notice) }

        context "新規作成ページを訪れたとき" do
          before { visit new_notice_reply_path(@notice) }

          it "ページが表示されること" do
            page.status_code.must_equal 200
          end

          context "正しい値を入力して保存したとき" do
            before do
              @reply_org = build(:reply)
              fill_in "reply_body", with: @reply_org.body
              click_button "Create Reply"
            end

            context "一覧を訪れたとき" do
              before { visit notice_replies_path(@notice) }

              it "表示されていること" do
                reply_list = find("#reply_list").text
                reply_list.must_include @reply_org.body
              end
            end
          end
        end
      end
    end

    context "ログインしていないとき" do
      context "きづきがあるとき" do
        before { @notice = create(:notice) }
        context "新規作成ページを訪れたとき" do
          before { visit new_notice_reply_path(@notice) }

          it "ログインページであること" do
            current_path.must_equal login_path
          end
        end
      end
    end
  end

  describe "編集" do
    context "ログインしているとき" do
      before do
        @user = login @user
      end

      context "きづきとそれへの自分の返信があるとき" do
        before do
          @notice = create(:notice)
          @reply = create(:reply, user_id: @user.id, notice_id: @notice.id)
        end

        context "編集画面を訪れたとき" do
          before { visit edit_notice_reply_path(notice_id: @notice.id, id: @reply.id) }

          it "内容が表示されていること" do
            page.html.must_include @reply.body
          end

          context "更新して保存したとき" do
            before do
              @reply_new = build(:reply)
              click_button "Update Reply"
            end

            context "一覧ページを訪れたとき" do
              before { visit notice_replies_path(@notice.id) }

              it "表示されていること" do
                reply_list = find("#reply_list").text
                reply_list.must_include @reply_new.body
              end
            end

            context "詳細ページを訪れたとき" do
              before { visit notice_reply_path(@notice, @reply) }

              it "表示されていること" do
                page.text.must_include @reply_new.body
              end
            end
          end
        end
      end

      context "きづきと他のひとの返信があるとき" do
        before do
          @notice = create(:notice)
          @user_another = create(:user)
          @reply = create(:reply, user_id: @user_another.id, notice_id: @notice.id)
        end

        context "編集画面を訪れたとき" do
          before { visit edit_notice_reply_path(notice_id: @notice.id, id: @reply.id) }

          it "404 not foundであること" do
            page.status_code.must_equal 404
          end
        end
      end
    end

    context "ログインしていないとき" do
      context "きづきと返信があるとき" do
        before do
          @notice = create(:notice)
          @reply = create(:reply, notice_id: @notice.id)
        end

        context "編集画面に訪れたとき" do
          before { visit edit_notice_reply_path(@notice, @reply) }

          it "ログインページであること" do
            current_path.must_equal login_path
          end
        end
      end
    end
  end
end
