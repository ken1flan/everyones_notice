require 'test_helper'

describe 'フィードバック Integration' do
  describe 'フィードバックを書く' do
    before { @user = login }

    context 'トップでfeedbackボタンを押したとき' do
      before do
        visit root_path
        click_button 'feedback_button'
      end

      context 'なにも書かないで送信ボタンを押したとき' do
        before do
          click_button '送る'
          sleep 2
        end

        it 'エラーが表示されること' do
          page.text.must_include 'を入力してください'
        end
      end

      context '内容を書いて送信ボタンを押したとき' do
        before do
          @feedback_body = 'テストテスト'
          fill_in 'feedback_body', with: @feedback_body
          click_button '送る'
          sleep 2
        end

        it '謝辞が表示されること' do
          page.text.must_include 'ありがとうございました'
        end

        context '管理者でフィードバック一覧ページを見たとき' do
          before do
            logout
            @admin_user = create_user_and_identity('twitter', nil, true)
            login(@admin_user)
            visit feedbacks_path
          end

          it '表示されていること' do
            page.text.must_include @feedback_body
          end

          context 'フィードバックをクリックしたとき' do
            before do
              click_link @feedback_body
            end

            it 'フィードバックの内容が表示されていること' do
              page.text.must_include @feedback_body
            end
          end
        end
      end
    end
  end

  describe '権限' do
    context '一般ユーザでフィードバック一覧を訪れたとき' do
      before do
        login
        visit feedbacks_path
      end

      it '表示されないこと' do
        page.status_code.must_equal 404
      end
    end

    context '一般ユーザでフィードバック詳細を訪れたとき' do
      before do
        @feedback = create(:feedback)
        login
        visit feedback_path(@feedback)
      end

      it '表示されないこと' do
        page.status_code.must_equal 404
      end
    end
  end
end
