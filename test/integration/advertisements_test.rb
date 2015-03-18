require "test_helper"

describe "おしらせの投稿 Integration" do
  describe "おしらせを投稿する" do
    before { @user = login }

    context "おしらせ一覧で新規追加ボタンを押したとき" do
      before do
        visit advertisements_path
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
            before { visit advertisements_path }

            it "タイトルとサマリーが表示されていること" do
              visit advertisements_path
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
          before { visit advertisements_path }

          it "タイトルとサマリーが表示されていること" do
            visit advertisements_path
            page.text.must_include @advertisement_data.title
            page.text.must_include @advertisement_data.summary
          end

          context "編集ボタンを押したとき" do
            before { click_link "編集" }

            context "正しい情報を入力して「登録する」ボタンを押したとき" do
              before do
                @advertisement_data_new = build(:advertisement)
                fill_in "advertisement_title", with: @advertisement_data_new.title
                fill_in "advertisement_summary", with: @advertisement_data_new.summary
                fill_in "advertisement_body", with: @advertisement_data_new.body
                fill_in "advertisement_started_on", with: @advertisement_data_new.started_on
                fill_in "advertisement_ended_on", with: @advertisement_data_new.ended_on
                click_button "更新する"
              end

              context "一覧画面を訪れたとき" do
                before { visit advertisements_path }
      
                it "タイトルとサマリーが表示されていること" do
                  visit advertisements_path
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
      end
    end
  end
end
