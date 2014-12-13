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
end
