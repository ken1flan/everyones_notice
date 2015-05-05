require "test_helper"

describe "返信 Integration" do
  describe "きづき詳細ページ内" do
    before do
      @user = login
      @notice = create(:notice)
      @base_id = "#{@notice.id}"
    end

    describe "新規作成" do
      context "きづき詳細ページを訪れたとき" do
        before { visit notice_path(@notice) }

        context "正しい値を入力したとき" do
          before do
            @reply = build(:reply)
            fill_in "reply_body_#{@base_id}", with: @reply.body
          end

          context "「プレビュー」をクリックしたとき" do
            before do
              click_link("プレビュー")
              sleep 1 # 反映されるまで少しタイムラグがあるので…
            end

            it "プレビューが表示されていること" do
              find("#new_reply").find(".markdown_body").text.must_include(@reply.body)
            end
          end

          context "「返信」したとき" do
            before do
              find(:css, '#new_reply').click_button "返信する"
              sleep 1 # 反映されるまで少しタイムラグがあるので…
            end

            it "入力内容が表示されていること" do
              page.text.must_include @reply.body
            end
          end
        end

        context "何も入力しないで「返信」したとき" do
          before do
            find(:css, "#new_reply").click_button "返信する"
            sleep 1 # 反映されるまで少しタイムラグがあるので…
          end

          it "エラーが表示されていること" do
            find(:css, "#new_reply").text.must_include "を入力してください"
          end
        end
      end
    end

    describe "編集" do
      before do
        @reply = create(:reply, user: @user, notice: @notice)
        @base_id = "#{@notice.id}_#{@reply.id}"
      end

      context "きづき詳細ページを訪れたとき" do
        before { visit notice_path(@notice) }

        context "「編集」を押したとき" do
          before do
            find(:css, "#reply_detail_#{@base_id}").click_link("編集")
            sleep 1 # 反映されるまで少しタイムラグがあるので…
          end

          context "正しい値を入力したとき" do
            before do
              @reply_new = build(:reply)
              fill_in "reply_body_#{@base_id}", with: @reply_new.body
            end

            context "「プレビュー」をクリックしたとき" do
              before do
                find("#reply_notice_builtin_form_#{@base_id}").click_link("プレビュー")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end
  
              it "プレビューが表示されていること" do
                find("#reply_notice_builtin_form_#{@base_id}").find(".markdown_body").text.must_include(@reply_new.body)
              end
            end

            context "「更新」したとき" do
              before do
                @reply_new = build(:reply)
                fill_in "reply_body_#{@base_id}", with: @reply_new.body
                find(:css, "#reply_notice_builtin_form_#{@base_id}").click_button("更新する")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              it "入力内容が表示されていること" do
                page.text.must_include @reply_new.body
              end
            end
          end

          context "空にして「更新」したとき" do
            before do
              fill_in "reply_body_#{@base_id}", with: ""
              find(:css, "#reply_notice_builtin_form_#{@base_id}").click_button "更新する"
              sleep 1 # 反映されるまで少しタイムラグがあるので…
            end

            it "エラーが表示されていること" do
              find(:css, "#reply_notice_builtin_form_#{@base_id}").text.must_include "を入力してください"
            end
          end
        end
      end
    end
  end

  describe "新規作成" do
    context "ログインしているとき" do
      before do
        @user = login
      end

      context "存在しないきづきの返信の新規作成ページを訪れたとき" do
        before { visit new_notice_reply_path(notice_id: 99999) }

        it "404 not foundであること" do
          page.status_code.must_equal 404
        end
      end

      context "きづきがあるとき" do
        before do
          @notice = create(:notice)
        end

        context "新規作成ページを訪れたとき" do
          before { visit new_notice_reply_path(@notice) }

          it "ページが表示されること" do
            page.status_code.must_equal 200
          end

          context "正しい値を入力して保存したとき" do
            before do
              @reply_org = build(:reply)
              fill_in "reply_body", with: @reply_org.body
              click_button "登録する"
            end

            context "一覧を訪れたとき" do
              before { visit notice_replies_path(@notice) }

              it "表示されていること" do
                reply_list = find("#reply_list").text
                reply_list.must_include @reply_org.body
              end
            end

            context "トップ画面を訪れたとき" do
              before { visit root_path }

              it "アクティビティが表示されていること" do
                find(:css, ".activity_list").text.must_include @user.nickname
                find(:css, ".activity_list").text.must_include @notice.title.truncate(15)
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
              fill_in "reply_body", with: @reply_new.body
              click_button "更新する"
            end

            context "一覧ページを訪れたとき" do
              before { visit notice_replies_path(@notice.id) }

              it "表示されていること" do
                reply_list = find("#reply_list").text
                reply_list.must_include @reply_new.body
              end
            end

            context "きづきの詳細ページを訪れたとき" do
              before { visit notice_path(@notice) }

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

  describe "いいね" do
    before do
      @notice = create(:notice)
      @reply = create(:reply, notice: @notice)
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "きづき詳細ページを訪れたとき" do
      before { visit notice_path(@notice) }

      context "「いいね」を押したとき" do
        before do
          click_button "like_reply_#{@reply.id}"
          sleep 1
        end

        it "ボタンの数値が1になること" do
          find(:css, "#like_reply_#{@reply.id}").text.must_include "1"
        end

        context "トップ画面を訪れたとき" do
          before { visit root_path }

          it "アクティビティが表示されていること" do
            find(:css, ".activity_list").text.must_include @user.nickname
            find(:css, ".activity_list").text.must_include @notice.title.truncate(15)
          end
        end

        context "「いいね」を解除したとき" do
          before do
            click_button "like_reply_#{@reply.id}"
            sleep 1
          end

          it "ボタンの数値が0になること" do
            find(:css, "#like_reply_#{@reply.id}").text.must_include "0"
          end
        end
      end
    end
  end
end
