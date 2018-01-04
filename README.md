# SugoiLogWatcher
* ログを監視してボトルネックを自動検出する
* 機能
  * railsのログを収集し、実行速度が閾値を超える行を通知する
    * スロークエリ
    * レンダリング
  * N+1 の検出
  * select 回数を通知する
  * 通知するフォーマットを設定ファイルで定義ができて、プロセスの再起動なしで設定ファイルを適宜読み込んで出力を変更する
  * webサーバを起動しておいて、過去に報告された通知を見ることができる

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sugoi_log_watcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sugoi_log_watcher

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sugoi_log_watcher.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
