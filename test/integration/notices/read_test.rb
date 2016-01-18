require 'test_helper'

describe 'きづきの既読 Integration' do
  before { login }

  describe '既読' do
    before do
      @notice = create(:notice)
      @user = create_user_and_identity('twitter')
      login @user
    end

    context '一覧ページを訪れたとき' do
      before { visit notices_path }

      context '「既読」を押したとき' do
        before do
          click_button "opened_notice_#{@notice.id}"
          sleep 1
        end

        it 'ボタンがOKになること' do
          find(:css, "#opened_notice_#{@notice.id}").has_css?('.glyphicon-ok').must_equal true
        end

        context '「既読」を解除したとき' do
          before do
            click_button "opened_notice_#{@notice.id}"
            sleep 1
          end

          it 'ボタンがminusになること' do
            find(:css, "#opened_notice_#{@notice.id}").has_css?('.glyphicon-minus').must_equal true
          end
        end
      end
    end
  end

  describe 'まだ読んでいないきづきを訪れると既読になる' do
    before do
      @user = create_user_and_identity('twitter')
      login @user
    end

    context '未読のきづきがあるとき' do
      before { @notice = create(:notice) }

      context 'まだ読んでいないきづきを訪れたとき' do
        before { visit unread_notices_path }

        it '表示されていること' do
          page.text.must_include @notice.title
        end

        context 'もう一度まだ読んでいないきづきを訪れたとき' do
          before { visit unread_notices_path }

          it '表示されていないこと' do
            page.text.wont_include @notice.title
          end
        end
      end
    end
  end

  describe '詳細ページを開いたときに既読になる' do
    context '未読のきづきがあったとき' do
      before { @notice = create(:notice) }

      it 'きづきすべての一覧に表示されていること' do
        visit notices_path
        page.text.must_include @notice.title
      end

      it '未読のきづきに表示されていること' do
        visit unread_notices_path
        page.text.must_include @notice.title
      end

      context '一覧ページで既読ボタンを押したとき' do
        before do
          visit notices_path
          click_button "opened_notice_#{@notice.id}"
          sleep 1
        end

        it 'きづきすべての一覧に表示されていること' do
          visit notices_path
          page.text.must_include @notice.title
        end

        it '未読のきづきに表示されていないこと' do
          visit unread_notices_path
          page.text.wont_include @notice.title
        end

        context 'きづきすべての一覧で既読を解除したとき' do
          before do
            visit notices_path
            click_button "opened_notice_#{@notice.id}"
            sleep 1
          end

          it 'きづきすべての一覧に表示されていること' do
            visit notices_path
            page.text.must_include @notice.title
          end

          it '未読のきづきに表示されていること' do
            visit unread_notices_path
            page.text.must_include @notice.title
          end
        end
      end

      context '詳細を開いたとき' do
        before { visit notice_path(@notice) }

        it 'きづきすべての一覧に表示されていること' do
          visit notices_path
          page.text.must_include @notice.title
        end

        it '未読のきづきに表示されていないこと' do
          visit unread_notices_path
          page.text.wont_include @notice.title
        end
      end
    end
  end
end
