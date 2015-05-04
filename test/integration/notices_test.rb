require "test_helper"

describe "きづき Integration" do
  describe "きづき一覧ページ内" do
    before do
      @user = login
    end

    describe "新規作成" do
      before { @base_id = "new" }

      context "きづき一覧ページを訪れたとき" do
        before { visit notices_path }

        context "新規作成ボタンを押したとき" do
          before do
            click_link "new_notice_button"
          end

          context "正しい値を入力したとき" do
            before do
              @notice_new = build(:notice)
              fill_in "notice_title_#{@base_id}", with: @notice_new.title
              fill_in "notice_body_#{@base_id}", with: @notice_new.body
              fill_in "notice_tags_string_#{@base_id}", with: "タグ1,タグ2"
            end

            context "「プレビュー」をクリックしたとき" do
              before do
                click_link("プレビュー")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              it "プレビューが表示されていること" do
                find(".markdown_body").text.must_include(@notice_new.body)
              end
            end

            context "「公開」を押したとき" do
              before do
                click_button("公開")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              context "きづき一覧を訪れたとき" do
                before { visit notices_path }

                it "きづきが表示されていること" do
                  page.text.must_include @notice_new.title
                  page.text.must_include @notice_new.body
                  page.text.must_include "タグ1"
                  page.text.must_include "タグ2"
                end
              end

              context "下書き一覧を訪れたとき" do
                before { visit draft_notices_path }

                it "きづきが表示されていないこと" do
                  page.text.wont_include @notice_new.title
                  page.text.wont_include @notice_new.body
                end
              end
            end

            context "「下書き」を押したとき" do
              before do
                click_button("下書き")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              context "きづき一覧を訪れたとき" do
                before { visit notices_path }

                it "きづきが表示されていないこと" do
                  page.text.wont_include @notice_new.title
                  page.text.wont_include @notice_new.body
                end
              end

              context "下書き一覧を訪れたとき" do
                before { visit draft_notices_path }

                it "きづきが表示されていること" do
                  page.text.must_include @notice_new.title
                  page.text.must_include @notice_new.body
                end
              end
            end
          end
        end
      end
    end

    describe "編集" do
      before do
        @notice = create(:notice, user: @user)
        @base_id = @notice.id
      end

      context "きづき一覧ページを訪れたとき" do
        before { visit notices_path }

        context "「編集」したとき" do
          before do
            find(:css, "#notice_detail_#{@base_id}").click_link("編集")
          end

          context "「プレビュー」をクリックしたとき" do
            before do
              click_link("プレビュー")
              sleep 1 # 反映されるまで少しタイムラグがあるので…
            end

            it "プレビューが表示されていること" do
              find(".markdown_body").text.must_include(@notice.body)
            end
          end

          context "正しい値を入力して「更新」したとき" do
            before do
              @notice_new = build(:notice)
              fill_in "notice_title_#{@base_id}", with: @notice_new.title
              fill_in "notice_body_#{@base_id}", with: @notice_new.body
              find(:css, "#notice_builtin_form_#{@base_id}").click_button("更新する")
              sleep 1 # 反映されるまで少しタイムラグがあるので…
            end

            it "入力内容が表示されていること" do
              page.text.must_include @notice_new.title
              page.text.must_include @notice_new.body
            end
          end
        end
      end
    end
  end

  describe "下書き一覧ページ内" do
    before do
      @user = login
    end

    describe "編集" do
      before do
        @notice = create(:notice, :draft, user: @user)
        @base_id = @notice.id
      end

      context "下書き一覧ページを訪れたとき" do
        before { visit draft_notices_path }

        context "「編集」したとき" do
          before do
            find(:css, "#notice_detail_#{@base_id}").click_link("編集")
            sleep 1 # 反映されるまで少しタイムラグがあるので…
          end

          context "正しい値を入力したとき" do
            before do
              @notice_new = build(:notice)
              fill_in "notice_title_#{@base_id}", with: @notice_new.title
              fill_in "notice_body_#{@base_id}", with: @notice_new.body
            end

            context "「下書き」を押したとき" do
              before do
                find(:css, "#notice_builtin_form_#{@base_id}").click_button("下書き")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              it "下書きのままであること" do
                find(:css, "#notice_detail_#{@base_id}").text.must_include "下書き"
              end
  
              it "入力内容が表示されていること" do
                page.text.must_include @notice_new.title
                page.text.must_include @notice_new.body
              end
            end

            context "「公開」を押したとき" do
              before do
                find(:css, "#notice_builtin_form_#{@base_id}").click_button("公開")
                sleep 1 # 反映されるまで少しタイムラグがあるので…
              end

              it "下書きでないこと" do
                find(:css, "#notice_detail_#{@base_id}").text.wont_include "下書き"
              end
  
              it "入力内容が表示されていること" do
                page.text.must_include @notice_new.title
                page.text.must_include @notice_new.body
              end
            end
          end
        end
      end
    end
  end

  describe "いいね" do
    before do
      @notice = create(:notice)
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "一覧ページを訪れたとき" do
      before { visit notices_path }

      context "「いいね」を押したとき" do
        before do
          click_button "like_notice_#{@notice.id}"
          sleep 1
        end

        it "ボタンの数値が1になること" do
          find(:css, "#like_notice_#{@notice.id}").text.must_include "1"
        end

        context "詳細ページを訪れたとき" do
          before { notice_path(@notice) }

          it "ボタンの数値が1であること" do
            find(:css, "#like_notice_#{@notice.id}").text.must_include "1"
          end
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
            click_button "like_notice_#{@notice.id}"
            sleep 1
          end

          it "ボタンの数値が0になること" do
            find(:css, "#like_notice_#{@notice.id}").text.must_include "0"
          end

          context "詳細ページを訪れたとき" do
            before { notice_path(@notice) }
  
            it "ボタンの数値が0であること" do
              find(:css, "#like_notice_#{@notice.id}").text.must_include "0"
            end
          end
        end
      end
    end
  end

  describe "今日のきづき" do
    before do
      login
    end

    context "昨日のきづきがあるとき" do
      before { @notice = create(:notice, published_at: 1.day.ago) }

      it "表示されないこと" do
        visit todays_notices_path
        wont_include_notice? page.text, @notice, @notice.user
      end
    end

    context "今日のきづきがあるとき" do
      before { @notice = create(:notice, published_at: Time.zone.now) }

      it "表示されること" do
        visit todays_notices_path
        must_include_notice? page.text, @notice, @notice.user
      end
    end

    context "明日のきづきがあるとき" do
      before { @notice = create(:notice, published_at: 1.day.since) }

      it "表示されること" do
        visit todays_notices_path
        must_include_notice? page.text, @notice, @notice.user
      end
    end
  end

  describe "まだ読んでいないきづき" do
    before do
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "未読のきづきがあるとき" do
      before { @notice = create(:notice) }

      it "表示されていること" do
        visit unread_notices_path
        page.text.must_include @notice.title
      end
    end

    context "下書きのきづきがあるとき" do
      before { @notice = create(:notice, :draft) }

      it "表示されていないこと" do
        visit unread_notices_path
        page.text.wont_include @notice.title
      end
    end

    context "既読のきづきがあるとき" do
      before do
        @notice = create(:notice)
        @notice.read_by @user
      end

      it "表示されていないこと" do
        visit unread_notices_path
        page.text.wont_include @notice.title
      end
    end

    context "ほかのひとが既読のきづきがあるとき" do
      before do
        another_user = create(:user)
        @notice = create(:notice)
        @notice.read_by another_user
      end

      it "表示されていること" do
        visit unread_notices_path
        page.text.must_include @notice.title
      end
    end
  end

  def wont_include_notice?(text, notice, user)
    text.wont_include notice.title
    text.wont_include user.nickname
  end

  def must_include_notice?(text, notice, user)
    text.must_include notice.title
    text.must_include user.nickname
  end

  describe "まだ読んでいないきづき" do
    before do
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "下書きのきづきがあるとき" do
      before do
        @notice = create(:notice, :draft)
      end

      it "表示されないこと" do
        visit unread_notices_path
        page.text.wont_include @notice.title
      end
    end

    context "読んでいないきづきがあるとき" do
      before do
        @notice = create(:notice)
      end

      it "表示されること" do
        visit unread_notices_path
        page.text.must_include @notice.title
      end
    end

    context "すでに読んだきづきがあるとき" do
      before do
        @notice = create(:notice)
        @notice.read_users << @user
      end

      it "表示されないこと" do
        visit unread_notices_path
        page.text.wont_include @notice.title
      end
    end
  end

  describe "下書きの一覧" do
    before do
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "下書きのきづきがあるとき" do
      before { @notice = create(:notice, :draft, user: @user) }

      it "表示されること" do
        visit draft_notices_path
        page.text.must_include @notice.title
      end
    end

    context "公開したきづきがあるとき" do
      before { @notice = create(:notice, user: @user) }

      it "表示されないこと" do
        visit draft_notices_path
        page.text.wont_include @notice.title
      end
    end

    context "ほかのひとの下書きのきづきがあるとき" do
      before do
        another_user = create(:user)
        @notice = create(:notice, :draft, user: another_user)
      end

      it "表示されないこと" do
        visit draft_notices_path
        page.text.wont_include @notice.title
      end
    end

    context "ほかのひとの公開したきづきがあるとき" do
      before do
        another_user = create(:user)
        @notice = create(:notice, user: another_user)
      end

      it "表示されないこと" do
        visit draft_notices_path
        page.text.wont_include @notice.title
      end
    end
  end

  describe "注目のきづき" do
    before do
      Notice.skip_callback(:save, :after, :register_activity)
      login
    end

    context "アクティビティが0〜12あるきづきがあるとき" do
      before do
        @notices = create_list(:notice, 13)
        @notices.each_with_index do |notice, activity_num|
          activity_num.times do
            create(
              :activity,
              notice: notice,
              type_id: Activity::type_ids[:thumbup_notice]
            )
          end
        end
      end

      context "注目のきづきの1ページ目を訪れたとき" do
        before { visit watched_notices_path }

        it "アクティビティ0のきづきは表示されないこと" do
          page.text.wont_include @notices[0].title
        end

        it "アクティビティ1、2のきづきは表示されないこと" do
          (1..2).each do |activity_num|
            page.text.wont_include @notices[activity_num].title
          end
        end

        it "アクティビティ3〜12のきづきは表示されていること" do
          (3..12).each do |activity_num|
            page.text.must_include @notices[activity_num].title
          end
        end
      end

      context "注目のきづきの1ページ目を訪れたとき" do
        before { visit watched_notices_path(page: 2) }

        it "アクティビティ0のきづきは表示されないこと" do
          page.text.wont_include @notices[0].title
        end

        it "アクティビティ1、2のきづきは表示されていること" do
          (1..2).each do |activity_num|
            page.text.must_include @notices[activity_num].title
          end
        end

        it "アクティビティ3〜12のきづきは表示されないこと" do
          (3..12).each do |activity_num|
            page.text.wont_include @notices[activity_num].title
          end
        end
      end
    end

    after { Notice.set_callback(:save, :after, :register_activity) }
  end

  describe "ワード検索" do
    before { login }

    context "ニックネーム「キムタク」であるユーザのきづきがあるとき" do
      before do
        @user = create(:user, nickname: "キムタク")
        @notice = create(:notice, user: @user)
        @user_not_selected = create(:user, nickname: "キム兄")
        @notice_not_selected = create(:notice, user: @user_not_selected)
        @notice_draft = create(:notice, :draft, user: @user)
        sleep 5 # solrのindexに時間がかかる
      end

      context "「キムタク」で検索したとき" do
        before do
          visit root_path
          fill_in "search", with: "キムタク"
          click_button "search_button"
        end

        it "表示されていること" do
          page.text.must_include @notice.title
          page.text.wont_include @notice_not_selected.title
          page.text.wont_include @notice_draft.title
        end
      end
    end

    context "タイトルに「あかさたな」が含まれるきづきがあるとき" do
      before do
        @notice = create(:notice, title: "xあかさたなy")
        @notice_not_selected = create(:notice, title: "xはまやらわy")
        @notice_draft = create(:notice, :draft, title: "zあかさたなz")
        sleep 5 # solrのindexに時間がかかる
      end

      context "「あかさたな」で検索したとき" do
        before do
          visit root_path
          fill_in "search", with: "あかさたな"
          click_button "search_button"
        end

        it "表示されていること" do
          page.text.must_include @notice.title
          page.text.wont_include @notice_not_selected.title
          page.text.wont_include @notice_draft.title
        end
      end
    end

    context "本文に「あかさたな」が含まれるきづきがあるとき" do
      before do
        @notice = create(:notice, body: "xあかさたなy")
        @notice_not_selected = create(:notice, body: "xはまやらわy")
        @notice_draft = create(:notice, :draft, body: "zあかさたなz")
        sleep 5 # solrのindexに時間がかかる
      end

      context "「あかさたな」で検索したとき" do
        before do
          visit root_path
          fill_in "search", with: "あかさたな"
          click_button "search_button"
        end

        it "表示されていること" do
          page.text.must_include @notice.title
          page.text.wont_include @notice_not_selected.title
          page.text.wont_include @notice_draft.title
        end
      end
    end

    context "返信に「あかさたな」が含まれるきづきがあるとき" do
      before do
        @notice = create(:notice)
        create(:reply, notice: @notice, body: "xあかさたなy")
        @notice_not_selected = create(:notice)
        create(:reply, notice: @notice_not_selected, body: "xはまやらわy")
        @notice_draft = create(:notice, :draft)
        create(:reply, notice: @notice_draft, body: "zあかさたなz")
        sleep 5 # solrのindexに時間がかかる
      end

      context "「あかさたな」で検索したとき" do
        before do
          visit root_path
          fill_in "search", with: "あかさたな"
          click_button "search_button"
        end

        it "表示されていること" do
          page.text.must_include @notice.title
          page.text.wont_include @notice_not_selected.title
          page.text.wont_include @notice_draft.title
        end
      end
    end
  end
end
