require "test_helper"

describe "アクティビティ Integration" do
  describe "表示アクティビティの種類" do
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

    context "自分の書いたお知らせがあるとき" do
      before { @advertisement = create(:advertisement, user: @user) }

      context "自分に関連するアクティビティの一覧ページを訪れたとき" do
        before { visit activities_path }

        it "アクティビティが表示されていること" do
          page.text.must_include @advertisement.title.slice(0, 10)
        end
      end

      context "すべてのアクティビティの一覧ページを訪れたとき" do
        before { visit all_activities_path }

        it "アクティビティが表示されていること" do
          page.text.must_include @advertisement.title.slice(0, 10)
        end
      end

      context "ほかのひとがおしらせにいいねしてくれたとき" do
        before do
          @thumbup_advertisement_user = create(:user)
          @advertisement.add_or_update_evaluation(:likes, 1, @thumbup_advertisement_user)
          create(:activity, advertisement: @advertisement, type_id: Activity.type_ids["thumbup_advertisement"], user: @thumbup_advertisement_user)
        end

        context "自分に関連するアクティビティの一覧ページを訪れたとき" do
          before { visit activities_path }
    
          it "アクティビティが表示されていること" do
            page.text.must_include @advertisement.title.slice(0, 10)
            page.text.must_include @thumbup_advertisement_user.nickname
          end
        end
    
        context "すべてのアクティビティの一覧ページを訪れたとき" do
          before { visit all_activities_path }
    
          it "アクティビティが表示されていること" do
            page.text.must_include @advertisement.title.slice(0, 10)
            page.text.must_include @thumbup_advertisement_user.nickname
          end
        end
      end
    end

  end

  describe "表示アクティビティの日付" do
    before { @user = login }

    context "2〜0日前の、自分/他のひとのアクティビティがそれぞれあるとき" do
      before do
        @notices = []
        @another_user_notices = []
        @activities = []
        @another_user_activities = []

        (0..2).each do |d|
          @notices[d] = create(:notice, user: @user, created_at: d.days.ago)
          @another_user_notices[d] = create(:notice, created_at: d.days.ago)
          @activities[d] = create(
            :activity,
            notice: @notices[d],
            user: @user,
            type_id: Activity.type_ids["thumbup_notice"],
            created_at: d.days.ago
          )

          @another_user_activities[d] = create(
            :activity,
            notice: @another_user_notices[d],
            type_id: Activity.type_ids["thumbup_notice"],
            created_at: d.days.ago
          )
        end
      end

      context "自分のアクティビティ一覧を訪れたとき" do
        before { visit activities_path }

        it "2〜0日前の自分のアクティビティが表示されていること" do
          (0..2).each do |d|
            page.text.must_include @notices[d].title
            page.text.wont_include @another_user_notices[d].title
          end
        end
      end

      context "自分のアクティビティ一覧を1日前を指定して訪れたとき" do
        before do
          date = 1.day.ago
          visit activities_user_path(@user, year: date.year, month: date.month, day: date.day)
        end

        it "1日前の自分のアクティビティが表示されていること" do
          page.text.wont_include @notices[0].title
          page.text.must_include @notices[1].title
          page.text.wont_include @notices[2].title
          (0..2).each do |d|
            page.text.wont_include @another_user_notices[d].title
          end
        end
      end

      context "すべてのアクティビティ一覧を訪れたとき" do
        before { visit all_activities_path }

        it "2〜0日前の自分のアクティビティが表示されていること" do
          (0..2).each do |d|
            page.text.must_include @notices[d].title
            page.text.must_include @another_user_notices[d].title
          end
        end
      end

      context "すべてのアクティビティ一覧を1日前を指定して訪れたとき" do
        before do
          date = 1.day.ago
          visit all_activities_path(year: date.year, month: date.month, day: date.day)
        end

        it "1日前のすべてのアクティビティが表示されていること" do
          page.text.must_include @notices[1].title
          page.text.must_include @another_user_notices[1].title
          [0, 2].each do |d|
            page.text.wont_include @notices[d].title
            page.text.wont_include @another_user_notices[d].title
          end
        end
      end
    end
  end
end
