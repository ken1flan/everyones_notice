require "test_helper"

describe "ユーザを招待する Integration" do
  context "ログインしているとき" do
    before do
      login
    end

    context "招待一覧ページを訪れたとき" do
      before do
        @invitation = create(:invitation)
        visit invitations_path
      end

      it "「招待の一覧」と表示されていること" do
        page.text.must_include "招待の一覧"
      end

      context "新規作成を押したとき" do
        before { click_link "新規作成" }

        it "「招待の新規作成」と表示されていること" do
          page.text.must_include "招待の新規作成"
        end
      end

      context "「削除」を押したとき" do
        before { click_link "delete_#{@invitation.id}" }

        it "削除した招待のメールアドレスが表示されていないこと" do
          page.text.wont_include @invitation.mail_address
        end
      end
    end

    context "招待の新規作成ページを訪れたとき" do
      before { visit new_invitation_path }

      it "「招待の新規作成」と表示されていること" do
        page.text.must_include "招待の新規作成"
      end

      context "正しい値を入力して、「作成」を押したとき" do
        before do
          @invitation = build :invitation
          fill_in "invitation_mail_address", with: @invitation.mail_address
          fill_in "invitation_message", with: @invitation.message
          click_button "作成"
        end

        it "入力値が表示されていること" do
          page.text.must_include @invitation.mail_address
          page.text.must_include @invitation.message
        end

        context "メールを受信したとき" do
          before do
            open_email @invitation.mail_address
            @new_users_path = current_email.text.match(/\/users\/new.*\w/).to_s
          end

          it "文面内のユーザ作成用URLでユーザ作成が表示できること" do
            visit @new_users_path
            current_path.must_equal new_user_path
          end

          context "メール内のユーザ作成リンクをクリックしたとき" do
            before do
              visit @new_users_path
            end

            context "「twitterアカウントで登録する」リンクをクリックしたとき" do
              before do
                @uid = rand(1000) + 1
                @nickname = "nickname_#{@uid}"
                set_auth_mock(:twitter, @uid, @nickname)
                click_link "twitterアカウントで登録する"
              end

              it "ニックネームが表示されていること" do
                page.text.must_include @nickname
              end
            end
          end
        end

        context "「一覧」ボタンを押したとき" do
          before { click_link "一覧" }

          it "メールアドレスが表示されていること" do
            page.text.must_include @invitation.mail_address
          end
        end
      end
    end
  end

  context "ログインしていないとき" do
    context "招待一覧ページを訪れたとき" do
      before do
        @invitation = create(:invitation)
        visit invitations_path
      end

      it "ログインページが表示されること" do
        current_path.must_equal login_path
      end
    end
  end
end
