require "test_helper"

describe "おしらせの投稿 Integration" do
  describe "おしらせを投稿する" do
    before { @user = login }

    context "おしらせ一覧で新規追加ボタンを押したとき" do
      before do
        visit all_advertisements_path
        click_link "新規作成"
      end

      context "なにも記入しないで「登録する」ボタンを押したとき" do
        before { click_button "登録する" }

        it "エラーが表示されること" do
          page.text.must_include "を入力してください"
        end

        context "正しい情報を入力して「登録する」ボタンを押したとき" do
          before do
            @advertisement_data = build(:advertisement)
            fill_in "advertisement_title", with: @advertisement_data.title
            fill_in "advertisement_summary", with: @advertisement_data.summary
            fill_in "advertisement_body", with: @advertisement_data.body
            fill_in "advertisement_started_on", with: @advertisement_data.started_on
            fill_in "advertisement_ended_on", with: @advertisement_data.ended_on
            click_button "登録する"
          end

          context "一覧画面を訪れたとき" do
            before { visit all_advertisements_path }

            it "タイトルとサマリーが表示されていること" do
              visit all_advertisements_path
              page.text.must_include @advertisement_data.title
              page.text.must_include @advertisement_data.summary
            end

            context "タイトルをクリックしたとき" do
              before { click_link @advertisement_data.title }

              it "タイトルと本文が表示されていること" do
                page.text.must_include @advertisement_data.title
                page.text.must_include @advertisement_data.body
              end
            end
          end
        end
      end

      context "正しい情報を入力したとき" do
        before do
          @advertisement_data = build(:advertisement)
          fill_in "advertisement_title", with: @advertisement_data.title
          fill_in "advertisement_summary", with: @advertisement_data.summary
          fill_in "advertisement_body", with: @advertisement_data.body
          fill_in "advertisement_started_on", with: @advertisement_data.started_on
          fill_in "advertisement_ended_on", with: @advertisement_data.ended_on
        end

        context "「プレビュー」ボタンを押したとき" do
          before do
            click_link "プレビュー"
          end

          it "プレビューの中に本文が表示されていること" do
            find(".markdown_body").text.must_include @advertisement_data.body
          end
        end

        context "「登録する」ボタンを押したとき" do
          before do
            @advertisement_data = build(:advertisement)
            fill_in "advertisement_title", with: @advertisement_data.title
            fill_in "advertisement_summary", with: @advertisement_data.summary
            fill_in "advertisement_body", with: @advertisement_data.body
            fill_in "advertisement_started_on", with: @advertisement_data.started_on
            fill_in "advertisement_ended_on", with: @advertisement_data.ended_on
            click_button "登録する"
          end

          context "一覧画面を訪れたとき" do
            before { visit all_advertisements_path }

            it "タイトルとサマリーが表示されていること" do
              visit all_advertisements_path
              page.text.must_include @advertisement_data.title
              page.text.must_include @advertisement_data.summary
            end

            context "編集ボタンを押したとき" do
              before { click_link "編集" }

              context "正しい情報を入力したとき" do
                before do
                  @advertisement_data_new = build(:advertisement)
                  fill_in "advertisement_title", with: @advertisement_data_new.title
                  fill_in "advertisement_summary", with: @advertisement_data_new.summary
                  fill_in "advertisement_body", with: @advertisement_data_new.body
                  fill_in "advertisement_started_on", with: @advertisement_data_new.started_on
                  fill_in "advertisement_ended_on", with: @advertisement_data_new.ended_on
                end

                context "「登録する」ボタンを押したとき" do
                  before do
                    click_link "プレビュー"
                  end

                  it "プレビューの中に本文が表示されていること" do
                    find(".markdown_body").text.must_include @advertisement_data_new.body
                  end
                end

                context "「登録する」ボタンを押したとき" do
                  before do
                    click_button "更新する"
                  end
  
                  context "一覧画面を訪れたとき" do
                    before { visit all_advertisements_path }
          
                    it "タイトルとサマリーが表示されていること" do
                      visit all_advertisements_path
                      page.text.must_include @advertisement_data_new.title
                      page.text.must_include @advertisement_data_new.summary
                    end
  
                    context "タイトルをクリックしたとき" do
                      before { click_link @advertisement_data_new.title }
      
                      it "タイトルと本文が表示されていること" do
                        page.text.must_include @advertisement_data_new.title
                        page.text.must_include @advertisement_data_new.body
                      end
                    end
                  end
                end
              end
            end

            context "タイトルをクリックしたとき" do
              before { click_link @advertisement_data.title }

              it "タイトルと本文が表示されていること" do
                page.text.must_include @advertisement_data.title
                page.text.must_include @advertisement_data.body
              end
            end
          end
        end
      end
    end
  end

  describe "他人による編集をさせない" do
    before { @user = login }

    context "ほかのひとの書いたおしらせがあるとき" do
      before { @advertisement = create(:advertisement) }

      context "一覧画面を訪れたとき" do
        before { visit all_advertisements_path }

        it "編集ボタンがないこと" do
          page.text.wont_include "編集"
        end
      end

      context "編集画面を直リンクでおとづれたとき" do
        before { visit edit_advertisement_path(@advertisement) }

        it "404 not foundであること" do
          page.status_code.must_equal 404
        end
      end
    end
  end

  describe "表示期間" do
    before { login }

    context "3日前〜昨日のおしらせがあるとき" do
      before do
        @advertisement = create(
          :advertisement,
          started_on: 3.days.ago.to_date,
          ended_on: 1.day.ago.to_date
        )
      end

      it "一覧を訪れたときに表示されないこと" do
        visit advertisements_path
        page.text.wont_include @advertisement.title
      end

      it "すべての一覧を訪れたときに表示されること" do
        visit all_advertisements_path
        page.text.must_include @advertisement.title
      end

      it "トップを訪れたときに表示されないこと" do
        visit root_path
        page.text.wont_include @advertisement.title
      end
    end
    
    context "3日前〜今日のおしらせがあるとき" do
      before do
        @advertisement = create(
          :advertisement,
          started_on: 3.days.ago.to_date,
          ended_on: 0.days.ago.to_date
        )
      end

      it "一覧を訪れたときに表示されること" do
        visit advertisements_path
        page.text.must_include @advertisement.title
      end

      it "すべての一覧を訪れたときに表示されること" do
        visit all_advertisements_path
        page.text.must_include @advertisement.title
      end

      it "トップを訪れたときに表示されること" do
        visit root_path
        page.text.must_include @advertisement.title
      end
    end

    context "今日〜今日のおしらせがあるとき" do
      before do
        @advertisement = create(
          :advertisement,
          started_on: 0.days.ago.to_date,
          ended_on: 0.days.ago.to_date
        )
      end

      it "一覧を訪れたときに表示されること" do
        visit advertisements_path
        page.text.must_include @advertisement.title
      end

      it "すべての一覧を訪れたときに表示されること" do
        visit all_advertisements_path
        page.text.must_include @advertisement.title
      end

      it "トップを訪れたときに表示されること" do
        visit root_path
        page.text.must_include @advertisement.title
      end
    end

    context "今日〜明日のおしらせがあるとき" do
      before do
        @advertisement = create(
          :advertisement,
          started_on: 0.days.ago.to_date,
          ended_on: 1.day.since.to_date
        )
      end

      it "一覧を訪れたときに表示されること" do
        visit advertisements_path
        page.text.must_include @advertisement.title
      end

      it "すべての一覧を訪れたときに表示されること" do
        visit all_advertisements_path
        page.text.must_include @advertisement.title
      end

      it "トップを訪れたときに表示されること" do
        visit root_path
        page.text.must_include @advertisement.title
      end
    end

    context "明日〜3日後のおしらせがあるとき" do
      before do
        @advertisement = create(
          :advertisement,
          started_on: 1.days.since.to_date,
          ended_on: 3.days.since.to_date
        )
      end

      it "一覧を訪れたときに表示されないこと" do
        visit advertisements_path
        page.text.wont_include @advertisement.title
      end

      it "すべての一覧を訪れたときに表示されること" do
        visit all_advertisements_path
        page.text.must_include @advertisement.title
      end

      it "トップを訪れたときに表示されないこと" do
        visit root_path
        page.text.wont_include @advertisement.title
      end
    end
  end

  describe "いいね" do
    before do
      @advertisement = create(:advertisement)
      @user = create_user_and_identity("twitter")
      login @user
    end

    context "詳細ページを訪れたとき" do
      before { visit advertisement_path(@advertisement) }

      context "「いいね」を押したとき" do
        before do
          click_button "like_advertisement_#{@advertisement.id}"
          sleep 1
        end

        it "ボタンの数値が1になること" do
          find(:css, "#like_advertisement_#{@advertisement.id}").text.must_include "1"
        end

        context "「いいね」を解除したとき" do
          before do
            click_button "like_advertisement_#{@advertisement.id}"
            sleep 1
          end

          it "ボタンの数値が0になること" do
            find(:css, "#like_advertisement_#{@advertisement.id}").text.must_include "0"
          end

          context "詳細ページを訪れたとき" do
            before { advertisement_path(@advertisement) }
  
            it "ボタンの数値が0であること" do
              find(:css, "#like_advertisement_#{@advertisement.id}").text.must_include "0"
            end
          end
        end
      end
    end
  end

end
