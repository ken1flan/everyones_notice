require "test_helper"

describe "きづき Integration" do
  describe "きづき一覧ページ内" do
    before do
      @user = login
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

  describe "新規作成" do
    context "ログインしているとき" do
      before do
        @user = create_user_and_identity("twitter")
        login @user
      end

      context "新規作成ページを訪れたとき" do
        before { visit new_notice_path }

        context "内容を入力したとき" do
          before do
            @notice_org = build :notice
            input_notice @notice_org
          end

          context "公開を押したとき" do
            before { click_button "公開" }

            context "一覧を訪れたとき" do
              before { visit notices_path }

              it "表示されていること" do
                notice_list = find("#notice_list").text
                must_include_notice?(notice_list, @notice_org, @user)
              end
            end

            context "トップ画面を訪れたとき" do
              before { visit root_path }

              it "アクティビティが表示されていること" do
                find(:css, ".activity_list").text.must_include @user.nickname
                find(:css, ".activity_list").text.must_include @notice_org.title
              end
            end
          end

          context "下書きを押したとき" do
            before { click_button "下書き" }

            context "一覧を訪れたとき" do
              before { visit notices_path }

              it "表示されていないこと" do
                notice_list = find("#notice_list").text
                wont_include_notice?(notice_list, @notice_org, @user)
              end
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

      context "自分の下書きしたきづきがあるとき" do
        before { @notice_org = create(:notice, :draft, user: @user) }

        context "編集画面に訪れたとき" do
          before { visit edit_notice_path(@notice_org) }

          context "内容を変更して、公開を押したとき" do
            before do
              @notice_new = build(:notice)
              input_notice @notice_new
              click_button "公開"
            end

            context "一覧画面を訪れたとき" do
              before { visit notices_path }

              it "変更した内容が反映されていること" do
                notice_list = find("#notice_list").text
                must_include_notice?(notice_list, @notice_new, @user)
              end
            end

            context "トップ画面を訪れたとき" do
              before { visit root_path }

              it "アクティビティが表示されていること" do
                find(:css, ".activity_list").text.must_include @user.nickname
                find(:css, ".activity_list").text.must_include @notice_new.title
              end
            end
          end

          context "内容を変更して、下書きを押したとき" do
            before do
              @notice_new = build(:notice)
              input_notice @notice_new
              click_button "下書き"
            end

            context "一覧画面を訪れたとき" do
              before { visit notices_path }

              it "表示されていないこと" do
                notice_list = find("#notice_list").text
                wont_include_notice?(notice_list, @notice_new, @user)
              end
            end
          end
        end
      end

      context "自分の公開したきづきがあるとき" do
        before { @notice_org = create :notice, user: @user }

        context "編集画面に訪れたとき" do
          before { visit edit_notice_path(@notice_org) }

          context "内容を変更して、公開を押したとき" do
            before do
              @notice_new = build(:notice)
              fill_in "notice_title", with: @notice_new.title
              fill_in "notice_body", with: @notice_new.body
              click_button "保存"
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
            find(:css, ".activity_list").text.must_include @notice.title
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

  describe "既読" do
    before do
      @notice = create(:notice)
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "一覧ページを訪れたとき" do
      before { visit notices_path }

      context "「既読」を押したとき" do
        before do
          click_button "opened_notice_#{@notice.id}"
          sleep 1
        end

        it "ボタンがOKになること" do
          find(:css, "#opened_notice_#{@notice.id}").has_css?(".glyphicon-ok").must_equal true
        end

        context "「既読」を解除したとき" do
          before do
            click_button "opened_notice_#{@notice.id}"
            sleep 1
          end

          it "ボタンがminusになること" do
            find(:css, "#opened_notice_#{@notice.id}").has_css?(".glyphicon-minus").must_equal true
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

  def input_notice(notice)
    fill_in "notice_title", with: notice.title
    fill_in "notice_body", with: notice.body
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
end
