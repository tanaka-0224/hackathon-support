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

JS 追加の仕方
Gemfile に gem "importmap-rails"
bundle install
bin/rails importmap:install
app/javascript ディレクトリを作る
javascript ディレクトリに*.js 作る
config/importmap.rb に pin "*", to: "_.js"
必要な view に以下を追加
<%= javascript_importmap_tags %>
<%= javascript_include_tag "_" %>
