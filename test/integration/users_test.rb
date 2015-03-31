require "test_helper"

describe "ユーザ管理 Integration" do
  describe "ユーザの新規作成" do
    context "トークンなしでユーザ作成ページへ訪れたとき" do
      before { visit new_user_path }

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "期限の切れたトークンでユーザ作成ページへ訪れたとき" do
      before do
        invitation = create(:invitation)
        invitation.update_attributes(expired_at: 1.day.ago)
        visit new_user_path( token: invitation.token )
      end

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "ユーザ登録の済んだトークンでユーザ作成ページへ訪れたとき" do
      before do
        invitation = create( :user_registered_invitation )
        visit new_user_path( token: invitation.token )
      end

      it "404 not foundであること" do
        page.status_code.must_equal 404
      end
    end

    context "正しいトークンでユーザ作成ページを訪れたとき" do
      before do
        invitation = create(:invitation)
        visit new_user_path(token: invitation.token)
      end

      it "200 OKであること" do
        page.status_code.must_equal 200
      end

      context "「twitterアカウントで登録する」ボタンを押したとき" do
        before do
          @user = build(:user)
          @identity = build(:identity)
          set_auth_mock("twitter", @identity.uid, @user.nickname)
          click_link "twitterアカウントで登録する"
        end

        context "「更新する」ボタンを押したとき" do
          before do
            click_button "更新する"
          end

          it "ユーザ情報が表示されていること" do
            page.text.must_include @user.nickname
            page.text.must_include @user.club.name
          end
        end

        context "内容を変更して「更新する」ボタンを押したとき" do
          before do
            @new_user_data = build(:user)
            fill_in :user_nickname, with: @new_user_data.nickname
            fill_in :user_belonging_to, with: @new_user_data.belonging_to
            click_button "更新する"
          end

          it "ユーザ情報が表示されていること" do
            page.text.must_include @new_user_data.nickname
            page.text.must_include @user.club.name
            page.text.must_include @new_user_data.belonging_to
          end
        end
      end
    end
  end

  describe "ユーザ詳細ページ" do
    context "ログインしているとき" do
      before do
        @user = create_user_and_identity("twitter")
        login @user
      end

      context "自分のユーザ詳細ページを訪れたとき" do
        before { visit user_path(@user) }

        it "自分の情報が表示されていること" do
          includes_user_info? page.text, @user
        end

        it "編集ボタンが表示されていること" do
          has_link?("edit_user_button_#{@user.id}").must_equal true
        end
      end

      context "同じクラブで他のユーザの詳細ページを訪れたとき" do
        before do
          @another_user = create(:user, club: @user.club)
          visit user_path @another_user
        end

        it "ユーザの情報が表示されていること" do
          includes_user_info? page.text, @another_user
        end

        it "編集ボタンが表示されていないこと" do
          has_link?("編集").must_equal false
        end

        context "他のユーザの編集画面を直接見ようとしたとき" do
          before { visit edit_user_path(@another_user) }

          it "404 not foundになること" do
            page.status_code.must_equal 404
          end
        end
      end
    end
  end

  describe "ユーザのきづき一覧ページ" do
    context "ユーザAとBがそれぞれ公開済みと下書きのきづきを持っているとき" do
      before do
        @club = create(:club)
        @users = {}
        @public_notices = {}
        @draft_notices = {}
        [:A, :B].each do |i|
          @users[i] = create_user_and_identity("twitter", @club)
          @public_notices[i] = create(:notice, user: @users[i])
          @draft_notices[i] = create(:notice, :draft, user: @users[i])
        end
      end

      context "ユーザAがログインしているとき" do
        before { login @users[:A] }

        context "自分のきづき一覧ページを訪れたとき" do
          before { visit notices_user_path(@users[:A]) }

          it "自分の公開中と下書きのきづきが表示されていること" do
            includes_notice_info? page.text, @public_notices[:A]
            includes_notice_info? page.text, @draft_notices[:A]
          end

          it "ユーザBの公開中と下書きのきづきは表示されていないこと" do
            not_includes_notice_info? page.text, @public_notices[:B]
            not_includes_notice_info? page.text, @draft_notices[:B]
          end
        end

        context "ユーザBのきづき一覧ページを訪れたとき" do
          before { visit notices_user_path(@users[:B]) }

          it "自分の公開中と下書きのきづきが表示されていないこと" do
            not_includes_notice_info? page.text, @public_notices[:A]
            not_includes_notice_info? page.text, @draft_notices[:A]
          end

          it "ユーザBの公開中のきづきは表示されていること" do
            includes_notice_info? page.text, @public_notices[:B]
          end

          it "ユーザBの下書きのきづきは表示されていないこと" do
            not_includes_notice_info? page.text, @draft_notices[:B]
          end
        end
      end
    end
  end

  describe "ユーザの返信一覧ページ" do
    context "ユーザAとBがそれぞれ返信を持っているとき" do
      before do
        @club = create(:club)
        @users = {}
        @notice_user = create(:user, club: @club)
        @notice = create(:notice, user: @notice_user)
        @replies = {}
        [:A, :B].each do |i|
          @users[i] = create_user_and_identity("twitter", @club)
          @replies[i] = create(:reply, user: @users[i], notice: @notice)
        end
      end

      context "ユーザAがログインしているとき" do
        before { login @users[:A] }

        context "自分の返信一覧ページを訪れたとき" do
          before { visit replies_user_path(@users[:A]) }

          it "自分の返信が表示されていること" do
            includes_reply_info? page.text, @replies[:A]
          end

          it "ユーザBの返信は表示されていないこと" do
            not_includes_reply_info? page.text, @replies[:B]
          end
        end

        context "ユーザBの返信一覧ページを訪れたとき" do
          before { visit replies_user_path(@users[:B]) }

          it "自分の返信が表示されていないこと" do
            not_includes_reply_info? page.text, @replies[:A]
          end

          it "ユーザBの返信は表示されていること" do
            includes_reply_info? page.text, @replies[:B]
          end
        end
      end
    end
  end

  describe "ユーザのアクティビティ" do
    before { login }

    context "ユーザがおり、アクティビティがあるとき" do
      before do
        @user = create(:user)
        @notice = create(:notice, user: @user)
      end

      context "もうひとりユーザがおり、アクティビティがあるとき" do
        before do
          @another_user = create(:user)
          @another_notice = create(:notice, user: @another_user)
        end

        context "ユーザのアクティビティページを訪れたとき" do
          before { visit activities_user_path(@user) }

          it "ユーザのアクティビティが表示されていること" do
            page.text.must_include @notice.title
          end

          it "もうひとりのユーザのアクティビティが表示されていないこと" do
            page.text.wont_include @another_notice.title
          end
        end
      end
    end
  end

  describe "ユーザの削除" do
    before { @user = create(:user) }

    context "管理者でないユーザでログインしたとき" do
      before do
        @no_admin_user = create_user_and_identity(:twitter, nil, false)
        login @no_admin_user
      end

      context "ユーザ一覧を訪れたとき" do
        before { visit users_path }

        it "削除ボタンがないこと" do
          page.text.must_include @user.nickname
          has_link?("destroy_user_button_#{@user.id}").must_equal false
        end
      end
    end

    context "管理者でログインしたとき" do
      before do
        @admin_user = create_user_and_identity(:twitter, nil, true)
        login @admin_user
      end

      context "ユーザ一覧を訪れたとき" do
        before { visit users_path }

        it "削除ボタンがあること" do
          page.text.must_include @user.nickname
          has_link?("destroy_user_button_#{@user.id}").must_equal true
        end

        context "削除ボタンを押したとき" do
          before do
            click_link("destroy_user_button_#{@user.id}")
            # 確認ダイアログがpoltergeistにはない
          end

          context "ユーザ一覧を訪れたとき" do
            before { visit users_path }

            it "ユーザのニックネームが表示されていないこと" do
              page.text.wont_include @user.nickname
            end
          end
        end
      end
    end
  end

  def includes_user_info?(text, user)
    text.must_include user.nickname
  end

  def includes_notice_info?(text, notice)
    text.must_include notice.title
    text.must_include notice.body
  end

  def not_includes_notice_info?(text, notice)
    text.wont_include notice.title
    text.wont_include notice.body
  end

  def includes_reply_info?(text, reply)
    text.must_include reply.body
  end

  def not_includes_reply_info?(text, reply)
    text.wont_include reply.body
  end
end
