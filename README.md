# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

JS 追加の仕方　 importmap の場合
Gemfile に gem "importmap-rails"
bundle install
bin/rails importmap:install
app/javascript ディレクトリを作る
javascript ディレクトリに*.js 作る
config/importmap.rb に pin "*", to: "_.js"
必要な view に以下を追加
<%= javascript_importmap_tags %>
<%= javascript_include_tag "_" %>

## 現在はこっち

JS 追加の仕方　 webpack の場合
app/javascript/packs に js ファイルを追加
rails webpacker:compile
キャッシュクリアの仕方：rails webpacker:clobber
\*compile するときは mysql、rails どちらも server を止めとく
application.js を作成し、html.erb に対応させたい場合
<%= javascript_pack_tag 'application' %>

issue ドリブン開発

issue の作成。（タスクの作成）
・タスクリストを使ってチェックボックスを作成する
・タスクの例：ボタンを押したら遷移すること(ことで終わらす)
・validation が実際あるか
・概要も書く場合あり
main ブランチから Issue に基づいたブランチを作成。
作成したブランチで開発を行い、コミットする。
プルリクエストを作成し、マージする。
繰り返す

プルリク：画像入れてわかりやすく

mysql.server start
rails s

プロジェクト作成：rails new chatapp

git の初期化と push まで（Github のリポジトリに書いてる）

top(最初だけ)の controller 作成：rails g controller home top

モデルとマイグレーションファイルを同時に作成：rails g model Model の名前 column 名 データ型
ex.Group model を作成)rails g model Group name:text

マイグレーションファイルの内容をデータベースに反映：rails db:migrate

ChatGPT API 記事
https://zenn.dev/code_journey_ys/articles/75b8b136dc53ec

#rails g model コマンドを取り消したいの場合
bundle exec rails destroy model モデル名

#rails g controller コマンドを取り消したいの場合
bundle exec rails destroy controller controller 名

params[:id]がデフォルトなので[]の中身をいじらない方が良い。
