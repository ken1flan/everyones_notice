source "https://rubygems.org"
source 'https://rails-assets.org'

gem "rails", "4.2.0"
gem "sass-rails", "~> 5.0.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "therubyracer", platforms: :ruby
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc

gem "zurui-sass-rails"                    # ズルいデザイン
gem "kaminari"                            # ページング
gem "redcarpet"                           # マークダウン
gem "active_decorator"                    # デコレータ
gem "activerecord-reputation-system"      # いいね
gem "omniauth"                            # OAuth
gem "omniauth-facebook"                   # OAuth for facebook
gem "omniauth-twitter"                    # OAuth for twitter
gem "omniauth-google-oauth2"              # OAuth for google
gem "sunspot_rails"                       # 全文検索

gem "rails-assets-bootstrap"              # 楽ちん部品
gem "rails-assets-cal-heatmap"            # カレンダー型ヒートマップ

group :development do
  gem 'web-console', '~> 2.0'             # ブラウザからconsoleが利用できる
  gem "spring"
  gem "rails-footnotes", ">= 4.0.0", "<5" # ページのフッタにデバッグ情報を表示
  gem "better_errors"                     # エラー画面をリッチに
  gem "letter_opener"                     # メールをブラウザで開く
  gem "annotate"                          # テーブル定義を各種ファイルに貼り付ける
  gem "squasher"                          # migrationファイルの圧縮
end

group :development, :test do
  gem "sqlite3"                           # 開発とテスト環境はとりあえずsqlite
  gem "pry-rails"                         # rails console でpryが使える
  gem "pry-doc"                           # クラスやメソッドのドキュメントやソースを参照
  gem "pry-byebug"                        # binding.pryでデバッガ起動
  gem "factory_girl_rails"                # fixturesより細やかなデータを記述できる
  gem "sunspot_solr"                      # sunspot用solrパック
end

group :test do
  gem "minitest-spec-rails"               # describeやitが使える
  gem "minitest-matchers"                 # いろいろなmatcher
  gem "minitest-reporters"                # minitestの実行結果をキレイに見せる
  gem "capybara"                          # integration testでブラウザ上の操作を記述できるようにする
  gem "capybara-email"                    # integration testでメールに対する記述をできるようにする
  gem "poltergeist"                       # capybaraのjsdriver。phantomjsを使う。
  gem "database_cleaner"                  # テスト時にdbのクリーンアップする方法を選択しやすくする。
  gem "timecop"                           # 時間を止めたり、変えたりする。
end

group :production do
  gem 'pg'                                # heroku用
  gem 'rails_12factor'                    # heroku用
end
