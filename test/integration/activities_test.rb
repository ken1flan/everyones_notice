require "test_helper"

describe "アクティビティ Integration" do
  before { @user = login }

  context "自分のきづきがあるとき" do
    before { @notice = create(:notice, user: @user) }

    context "自分に関連するアクティビティの一覧ページを訪れたとき" do
      before { visit activities_path }

      it "アクティビティが表示されていること" do
        page.text.must_include @notice.title.slice(0, 10)
      end
    end

    context "すべてのアクティビティの一覧ページを訪れたとき" do
      before { visit all_activities_path }

      it "アクティビティが表示されていること" do
        page.text.must_include @notice.title.slice(0, 10)
      end
    end

    context "ほかのひとがきづきにいいねしてくれたとき" do
      before do
        @thumbup_notice_user = create(:user)
        @notice.add_or_update_evaluation(:likes, 1, @thumbup_notice_user)
        create(:activity, notice: @notice, type_id: Activity.type_ids["thumbup_notice"], user: @thumbup_notice_user)
      end

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
          page.text.must_include @thumbup_notice_user.nickname
        end
      end
  
      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
          page.text.must_include @thumbup_notice_user.nickname
        end
      end
    end
  end

  context "ほかのひとのきづきがあるとき" do
    before { @notice = create(:notice) }

    context "自分に関連するアクティビティの一覧ページを訪れたとき" do
      before { visit activities_path }

      it "アクティビティが表示されていること" do
        page.text.wont_include @notice.title.slice(0, 10)
      end
    end

    context "すべてのアクティビティの一覧ページを訪れたとき" do
      before { visit all_activities_path }

      it "アクティビティが表示されていること" do
        page.text.must_include @notice.title.slice(0, 10)
      end
    end

    context "きづきにいいねしたとき" do
      before do
        @notice.add_or_update_evaluation(:likes, 1, @user)
        create(:activity, notice: @notice, type_id: Activity.type_ids["thumbup_notice"], user: @user)
      end

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
        end
      end
  
      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
        end
      end
    end

    context "ほかのひとがきづきにいいねしたとき" do
      before do
        @another_user = create(:user)
        @notice.add_or_update_evaluation(:likes, 1, @another_user)
        create(:activity, notice: @notice, type_id: Activity.type_ids["thumbup_notice"], user: @another_user)
      end

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }
  
        it "アクティビティが表示されていないこと" do
          page.text.wont_include @notice.title.slice(0, 10)
          page.text.wont_include @another_user.nickname
        end
      end
  
      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
          page.text.must_include @another_user.nickname
        end
      end
    end

    context "きづきに返信したとき" do
      before do
        @reply = create(:reply, notice: @notice, user: @user)
      end

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }
  
        it "アクティビティが表示されてること" do
          page.text.must_include @notice.title.slice(0, 10)
        end
      end
  
      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
        end
      end
    end

    context "ほかのひとがきづきに返信したとき" do
      before do
        @reply = create(:reply, notice: @notice)
      end

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }
  
        it "アクティビティが表示されていないこと" do
          page.text.wont_include @notice.title.slice(0, 10)
          page.text.wont_include @reply.user.nickname
        end
      end
  
      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }
  
        it "アクティビティが表示されていること" do
          page.text.must_include @notice.title.slice(0, 10)
          page.text.must_include @reply.user.nickname
        end
      end

      context "返信にいいねしたとき" do
        before do
          @reply.add_or_update_evaluation(:likes, 1, @user)
          create(:activity, notice: @notice, reply: @reply, type_id: Activity.type_ids["thumbup_reply"], user: @user)
        end
  
        context "自分に関連するアクティビティの一覧ページを訪れたとき" do
          before { visit activities_path }
    
          it "アクティビティが表示されていること" do
            page.text.must_include @notice.title.slice(0, 10)
          end
        end
    
        context "すべてのアクティビティの一覧ページを訪れたとき" do
          before { visit all_activities_path }
    
          it "アクティビティが表示されていること" do
            page.text.must_include @notice.title.slice(0, 10)
          end
        end
      end

      context "ほかのひとが返信にいいねしたとき" do
        before do
          @another_user = create(:user)
          @reply.add_or_update_evaluation(:likes, 1, @another_user)
          create(:activity, notice: @notice, reply: @reply, type_id: Activity.type_ids["thumbup_reply"], user: @another_user)
        end
  
        context "自分に関連するアクティビティの一覧ページを訪れたとき" do
          before { visit activities_path }
    
          it "アクティビティが表示されていないこと" do
            page.text.wont_include @notice.title.slice(0, 10)
            page.text.wont_include @another_user.nickname
          end
        end
    
        context "すべてのアクティビティの一覧ページを訪れたとき" do
          before { visit all_activities_path }
    
          it "アクティビティが表示されていること" do
            page.text.must_include @notice.title.slice(0, 10)
            page.text.must_include @another_user.nickname
          end
        end
      end
    end
  end
end
