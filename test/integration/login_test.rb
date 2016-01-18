require 'test_helper'

describe 'ログイン・ログアウト Integration' do
  Identity::PROVIDERS.each do |provider|
    provider_name = provider == 'google_oauth2' ? 'google' : provider

    describe "#{provider_name}アカウントログイン" do
      before do
        @user = create_user_and_identity(provider)
        set_auth_mock(@user.identities.first.provider, @user.identities.first.uid, @user.nickname)
      end

      context 'ログインページを訪れたとき' do
        before { visit login_path }

        context "#{provider_name}ログインをクリックしたとき" do
          before { click_link "#{provider_name}" }

          it 'トップページであること' do
            current_path.must_equal root_path
          end

          it 'ニックネームが表示されていること' do
            page.text.must_include @user.nickname
          end
        end
      end
    end
  end

  describe 'トップページ' do
    context 'twitterアカウントを登録したユーザがいるとき' do
      before do
        user = create_user_and_identity('twitter')
        set_auth_mock(user.identities.first.provider, user.identities.first.uid, user.nickname)
      end

      context 'ログインしていないとき' do
        context 'トップページを訪れたとき' do
          before { visit root_path }

          it 'ログインページが表示されること' do
            current_path.must_equal login_path
          end

          context 'ログインしたとき' do
            before do
              click_link 'twitter'
            end

            it 'トップページが表示されること' do
              current_path.must_equal root_path
            end
          end
        end
      end
    end
  end
end
