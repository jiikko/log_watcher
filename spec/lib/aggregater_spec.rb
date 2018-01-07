require 'spec_helper'

RSpec.describe SugoiLogWatcher::Aggregater do
  after(:all) do
    TerminalNotifier.remove(Process.pid)
  end

  context 'N+1がある時' do
    it 'N+1を検出すること' do
      log = <<~EOH
        I, [2018-01-05T21:12:17.293087 #68534]  INFO -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms state=ready
        D, [2018-01-05T21:12:17.293680 #68534] DEBUG -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms service=1ms state=active
        I, [2018-01-05T21:12:17.294814 #68534]  INFO -- : Started GET "/" for 127.0.0.1 at 2018-01-05 21:12:17 +0900
        D, [2018-01-05T21:12:17.510929 #68534] DEBUG -- :   ActiveRecord::SchemaMigration Load (6.7ms)  SELECT `schema_migrations`.* FROM `schema_migrations`
        I, [2018-01-05T21:12:17.687017 #68534]  INFO -- : Processing by WelcomeController#index as */*
        I, [2018-01-05T21:12:17.687297 #68534]  INFO -- :   Parameters: {"locale"=>"ja"}
        D, [2018-01-05T21:12:17.739540 #68534] DEBUG -- :   Account Load (7.0ms)  SELECT  `accounts`.* FROM `accounts` LIMIT 20
        D, [2018-01-05T21:12:17.823438 #68534] DEBUG -- :   Profile Load (21.5ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 843 LIMIT 1
        D, [2018-01-05T21:12:17.846054 #68534] DEBUG -- :   Profile Load (0.3ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 844 LIMIT 1
        D, [2018-01-05T21:12:17.847168 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 845 LIMIT 1
        D, [2018-01-05T21:12:17.848309 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 846 LIMIT 1
        D, [2018-01-05T21:12:17.849316 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 847 LIMIT 1
        D, [2018-01-05T21:12:17.850250 #68534] DEBUG -- :   Profile Load (0.1ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 848 LIMIT 1
        D, [2018-01-05T21:12:17.851219 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 849 LIMIT 1
        D, [2018-01-05T21:12:17.852234 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 850 LIMIT 1
        D, [2018-01-05T21:12:17.853128 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 851 LIMIT 1
        D, [2018-01-05T21:12:17.854025 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 852 LIMIT 1
        D, [2018-01-05T21:12:17.854995 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 853 LIMIT 1
        I, [2017-12-31T17:17:43.186163 #52408]  INFO -- :   Rendering session/new.html.haml within layouts/welcome
        I, [2017-12-31T17:17:43.197143 #52408]  INFO -- :   Rendered layouts/_ie_dialog.ja.html.haml (6.0ms)
        I, [2017-12-31T17:17:43.197495 #52408]  INFO -- :   Rendered session/new.html.haml within layouts/welcome (11.3ms)
        I, [2017-12-31T17:17:43.212764 #52408]  INFO -- :   Rendered shared/_goog.html.haml (2.4ms)
        I, [2017-12-31T17:17:43.219046 #52408]  INFO -- :   Rendered shared/_es5_shim.haml (1.2ms)
        I, [2017-12-31T17:17:43.225821 #52408]  INFO -- :   Rendered layouts/_airbrake_js.html.haml (1.4ms)
        I, [2017-12-31T17:17:43.229540 #52408]  INFO -- :   Rendered layouts/_rem.ja.html.haml (2.6ms)
        I, [2017-12-31T17:17:43.232852 #52408]  INFO -- :   Rendered shared/_ok.html.haml (1.7ms)
        I, [2017-12-31T17:17:43.234780 #52408]  INFO -- :   Rendered shared/_v.html.haml (0.9ms)
        I, [2017-12-31T17:17:43.235821 #52408]  INFO -- :   Rendered shared/_google_tag_manager.html.haml (0.0ms)
        I, [2017-12-31T17:17:43.238552 #52408]  INFO -- :   Rendered shared/_faceb.html.haml (1.7ms)
        I, [2017-12-31T17:17:43.244562 #52408]  INFO -- :   Rendered layouts/_topb.html.haml (5.0ms)
        I, [2017-12-31T17:17:43.251875 #52408]  INFO -- :   Rendered layouts/_navi.html.haml (6.1ms)
        I, [2017-12-31T17:17:43.256497 #52408]  INFO -- :   Rendered layouts/_brea.html.haml (3.1ms)
        I, [2017-12-31T17:17:43.268275 #52408]  INFO -- :   Rendered layouts/_foo.html.haml (10.5ms)
        I, [2017-12-31T17:17:43.271796 #52408]  INFO -- :   Rendered layouts/_cop.html.haml (2.1ms)
        I, [2017-12-31T17:17:43.274854 #52408]  INFO -- :   Rendered layouts/_bot.html.haml (2.0ms)
        I, [2017-12-31T17:17:43.278307 #52408]  INFO -- :   Rendered shared/_yaho.html.haml (1.9ms)
        I, [2018-01-05T21:12:18.832405 #68534]  INFO -- : Completed 200 OK in 1145ms (Views: 956.8ms | ActiveRecord: 72.5ms)
      EOH
      aggregater = SugoiLogWatcher::Aggregater.new
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.complated.last.n1_queries).to eq([
        ["SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = N LIMIT N", 11]
      ])
    end
  end
  context '1リクエストのログが2回分のログに分かれている時' do
    it '2回目で集計した時に集計できること' do
      log = <<~EOH
        I, [2018-01-05T21:12:17.293087 #68534]  INFO -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms state=ready
        D, [2018-01-05T21:12:17.293680 #68534] DEBUG -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms service=1ms state=active
        I, [2018-01-05T21:12:17.294814 #68534]  INFO -- : Started GET "/" for 127.0.0.1 at 2018-01-05 21:12:17 +0900
        D, [2018-01-05T21:12:17.510929 #68534] DEBUG -- :   ActiveRecord::SchemaMigration Load (6.7ms)  SELECT `schema_migrations`.* FROM `schema_migrations`
        I, [2018-01-05T21:12:17.687017 #68534]  INFO -- : Processing by WelcomeController#index as */*
        I, [2018-01-05T21:12:17.687297 #68534]  INFO -- :   Parameters: {"locale"=>"ja"}
        D, [2018-01-05T21:12:17.739540 #68534] DEBUG -- :   Account Load (7.0ms)  SELECT  `accounts`.* FROM `accounts` LIMIT 20
        D, [2018-01-05T21:12:17.823438 #68534] DEBUG -- :   Profile Load (21.5ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 843 LIMIT 1
        D, [2018-01-05T21:12:17.846054 #68534] DEBUG -- :   Profile Load (0.3ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 844 LIMIT 1
        D, [2018-01-05T21:12:17.847168 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 845 LIMIT 1
        D, [2018-01-05T21:12:17.848309 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 846 LIMIT 1
        D, [2018-01-05T21:12:17.849316 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 847 LIMIT 1
        D, [2018-01-05T21:12:17.850250 #68534] DEBUG -- :   Profile Load (0.1ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 848 LIMIT 1
        D, [2018-01-05T21:12:17.851219 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 849 LIMIT 1
        D, [2018-01-05T21:12:17.852234 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 850 LIMIT 1
        D, [2018-01-05T21:12:17.853128 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 851 LIMIT 1
        D, [2018-01-05T21:12:17.854025 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 852 LIMIT 1
        D, [2018-01-05T21:12:17.854995 #68534] DEBUG -- :   Profile Load (0.2ms)  SELECT  `profiles`.* FROM `profiles` WHERE `profiles`.`account_id` = 853 LIMIT 1
      EOH
      aggregater = SugoiLogWatcher::Aggregater.new
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.buffer).not_to eq([])
      expect(aggregater.complated.size).to eq(0)

      log = <<~EOH
        I, [2017-12-31T17:17:43.225821 #68534]  INFO -- :   Rendered layouts/_airbrake_js.html.haml (1.4ms)
        I, [2017-12-31T17:17:43.229540 #68534]  INFO -- :   Rendered layouts/_rem.ja.html.haml (2.6ms)
        I, [2017-12-31T17:17:43.232852 #68534]  INFO -- :   Rendered shared/_ok.html.haml (1.7ms)
        I, [2017-12-31T17:17:43.234780 #68534]  INFO -- :   Rendered shared/_v.html.haml (0.9ms)
        I, [2017-12-31T17:17:43.235821 #68534]  INFO -- :   Rendered shared/_google_tag_manager.html.haml (0.0ms)
        I, [2017-12-31T17:17:43.238552 #68534]  INFO -- :   Rendered shared/_faceb.html.haml (1.7ms)
        I, [2017-12-31T17:17:43.244562 #68534]  INFO -- :   Rendered layouts/_topb.html.haml (5.0ms)
        I, [2017-12-31T17:17:43.251875 #68534]  INFO -- :   Rendered layouts/_navi.html.haml (6.1ms)
        I, [2017-12-31T17:17:43.256497 #68534]  INFO -- :   Rendered layouts/_brea.html.haml (3.1ms)
        I, [2017-12-31T17:17:43.268275 #68534]  INFO -- :   Rendered layouts/_foo.html.haml (10.5ms)
        I, [2017-12-31T17:17:43.271796 #68534]  INFO -- :   Rendered layouts/_cop.html.haml (2.1ms)
        I, [2017-12-31T17:17:43.274854 #68534]  INFO -- :   Rendered layouts/_bot.html.haml (2.0ms)
        I, [2017-12-31T17:17:43.278307 #68534]  INFO -- :   Rendered shared/_yaho.html.haml (1.9ms)
        I, [2018-01-05T21:12:18.832405 #68534]  INFO -- : Completed 200 OK in 1145ms (Views: 956.8ms | ActiveRecord: 72.5ms)
      EOH
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.buffer).to eq([])
      expect(aggregater.complated.size).to eq(1)
      expect(aggregater.complated.last.n1_queries).not_to eq([])
      expect(aggregater.complated.last.responsetime).to eq(
        :total=>"1145", "Views"=>"956.8", "ActiveRecord"=>"72.5"
      )
    end
  end

  context 'ログにmessage type: end がない時(不完全なログ)' do
    it 'complated に格納しない' do
      log = <<~EOH
        I, [2018-01-05T21:12:17.293087 #68534]  INFO -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms state=ready
        D, [2018-01-05T21:12:17.293680 #68534] DEBUG -- : source=rack-timeout id=991fdc297ee601a3c755ad2c70c3ff41 timeout=280000ms service=1ms state=active
        I, [2018-01-05T21:12:17.294814 #68534]  INFO -- : Started GET "/" for 127.0.0.1 at 2018-01-05 21:12:17 +0900
        D, [2018-01-05T21:12:17.510929 #68534] DEBUG -- :   ActiveRecord::SchemaMigration Load (6.7ms)  SELECT `schema_migrations`.* FROM `schema_migrations`
        I, [2018-01-05T21:12:17.687017 #68534]  INFO -- : Processing by WelcomeController#index as */*
        I, [2018-01-05T21:12:17.687297 #68534]  INFO -- :   Parameters: {"locale"=>"ja"}
        D, [2018-01-05T21:12:17.739540 #68534] DEBUG -- :   Account Load (7.0ms)  SELECT  `accounts`.* FROM `accounts` LIMIT 20
      EOH
      aggregater = SugoiLogWatcher::Aggregater.new
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.complated).to eq([])
    end
  end
  context '1つのログ' do
    it '集計すること' do
      log = <<~EOH
      I, [2017-12-31T17:17:43.078024 #52408]  INFO -- : Started POST "/login" for 127.0.0.1 at 2017-12-31 17:17:43 +0900
      I, [2017-12-31T17:17:43.080320 #52408]  INFO -- : Processing by SessionController#create as HTML
      I, [2017-12-31T17:17:43.080393 #52408]  INFO -- :   Parameters: {"utf8"=>"✓", "authenticity_token"=>"XHy9TVK+", "path"=>"", "email"=>"sample@sample.com", "password"=>"[FILTERED]", "commit"=>"ログイン"}
      D, [2017-12-31T17:17:43.183631 #52408] DEBUG -- :   Account Load (6.9ms)  SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`email` = 'sample@sample.com' ORDER BY `accounts`.`id` ASC LIMIT 1
      I, [2017-12-31T17:17:43.186163 #52408]  INFO -- :   Rendering session/new.html.haml within layouts/welcome
      I, [2017-12-31T17:17:43.197143 #52408]  INFO -- :   Rendered layouts/_ie_dialog.ja.html.haml (6.0ms)
      I, [2017-12-31T17:17:43.197495 #52408]  INFO -- :   Rendered session/new.html.haml within layouts/welcome (11.3ms)
      I, [2017-12-31T17:17:43.212764 #52408]  INFO -- :   Rendered shared/_goog.html.haml (2.4ms)
      I, [2017-12-31T17:17:43.219046 #52408]  INFO -- :   Rendered shared/_es5_shim.haml (1.2ms)
      I, [2017-12-31T17:17:43.225821 #52408]  INFO -- :   Rendered layouts/_airbrake_js.html.haml (1.4ms)
      I, [2017-12-31T17:17:43.229540 #52408]  INFO -- :   Rendered layouts/_rem.ja.html.haml (2.6ms)
      I, [2017-12-31T17:17:43.232852 #52408]  INFO -- :   Rendered shared/_ok.html.haml (1.7ms)
      I, [2017-12-31T17:17:43.234780 #52408]  INFO -- :   Rendered shared/_v.html.haml (0.9ms)
      I, [2017-12-31T17:17:43.235821 #52408]  INFO -- :   Rendered shared/_google_tag_manager.html.haml (0.0ms)
      I, [2017-12-31T17:17:43.238552 #52408]  INFO -- :   Rendered shared/_faceb.html.haml (1.7ms)
      I, [2017-12-31T17:17:43.244562 #52408]  INFO -- :   Rendered layouts/_topb.html.haml (5.0ms)
      I, [2017-12-31T17:17:43.251875 #52408]  INFO -- :   Rendered layouts/_navi.html.haml (6.1ms)
      I, [2017-12-31T17:17:43.256497 #52408]  INFO -- :   Rendered layouts/_brea.html.haml (3.1ms)
      I, [2017-12-31T17:17:43.268275 #52408]  INFO -- :   Rendered layouts/_foo.html.haml (10.5ms)
      I, [2017-12-31T17:17:43.271796 #52408]  INFO -- :   Rendered layouts/_cop.html.haml (2.1ms)
      I, [2017-12-31T17:17:43.274854 #52408]  INFO -- :   Rendered layouts/_bot.html.haml (2.0ms)
      I, [2017-12-31T17:17:43.278307 #52408]  INFO -- :   Rendered shared/_yaho.html.haml (1.9ms)
      I, [2017-12-31T17:17:43.278759 #52408]  INFO -- : Completed 200 OK in 198ms (Views: 94.6ms | ActiveRecord: 98.0ms)
      EOH
      aggregater = SugoiLogWatcher::Aggregater.new
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.complated.size).to eq(1)
    end
  end

  context '2プロセスのログ' do
    it 'プロセス単位毎に集計すること' do
      log = <<~EOH
        I, [2017-12-31T18:52:22.596118 #57531]  INFO -- :   Rendered dashboard/_setup_warnings_js_code.html.haml (5.6ms)
        D, [2017-12-31T18:52:22.603659 #57531] DEBUG -- :   Subscription Exists (0.4ms)  SELECT  1 AS one FROM `subscriptions` WHERE `subscriptions`.`account_id` = 864 AND `subscriptions`.`deleted_at` IS NULL AND `subscriptions`.`deleted_at` IS NULL AND `subscriptions`.`kind` = 1 AND (start_at <= '2017-12-31 09:52:22.602519') AND (expire_at IS NULL OR '2017-12-31 09:52:22.602519' < expire_at) LIMIT 1
        I, [2017-12-31T18:52:22.606649 #57531]  INFO -- :   Rendered layouts/_setup_albatross_js_code.html.haml (9.3ms)
        I, [2017-12-31T18:52:22.607315 #57531]  INFO -- : Completed 200 OK in 350ms (Views: 113.5ms | ActiveRecord: 187.7ms)
        I, [2017-12-31T18:52:22.608285 #57531]  INFO -- : source=rack-timeout id=ad6686693bae99c7bd41ef66bd212433 timeout=280000000000ms service=357ms state=completed
        I, [2017-12-31T18:52:23.407765 #57531]  INFO -- : source=rack-timeout id=1e8539043ad3edb145b4c6e6d6b90ce7 timeout=280000000000ms state=ready
        D, [2017-12-31T18:52:23.408094 #57531] DEBUG -- : source=rack-timeout id=1e8539043ad3edb145b4c6e6d6b90ce7 timeout=280000000000ms service=0ms state=active
        I, [2017-12-31T18:52:23.408871 #57531]  INFO -- : Started GET "/api/a/accounts/864/notifications?need_render=summary&page_size=5&type=unread" for ::1 at 2017-12-31 18:52:23 +0900
        I, [2017-12-31T18:52:23.409463 #57530]  INFO -- : source=rack-timeout id=42ea6104ec6a774a6a547e0b978b140e timeout=280000000000ms state=ready
        I, [2017-12-31T18:52:23.409787 #57530]  INFO -- : Started GET "/api/a/accounts/864/notifications/status" for ::1 at 2017-12-31 18:52:23 +0900
        D, [2017-12-31T18:52:23.409879 #57530] DEBUG -- : source=rack-timeout id=42ea6104ec6a774a6a547e0b978b140e timeout=280000000000ms service=0ms state=active
        I, [2017-12-31T18:52:23.412411 #57530]  INFO -- : Processing by Internal::Albatross::Account::NotificationsController#status as JSON
        I, [2017-12-31T18:52:23.412544 #57531]  INFO -- : Processing by Internal::Albatross::Account::NotificationsController#index as JSON
        I, [2017-12-31T18:52:23.412665 #57530]  INFO -- :   Parameters: {"account_id"=>"864"}
        I, [2017-12-31T18:52:23.412764 #57531]  INFO -- :   Parameters: {"need_render"=>"summary", "page_size"=>"5", "type"=>"unread", "account_id"=>"864"}
        D, [2017-12-31T18:52:23.414671 #57531] DEBUG -- :   Account Load (0.3ms)  SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = 864 LIMIT 1
        D, [2017-12-31T18:52:23.417662 #57531] DEBUG -- :   Notification Load (0.6ms)  SELECT  `notifications`.* FROM `notifications` WHERE `notifications`.`account_id` = 864 AND (read_at IS NULL) ORDER BY created_at DESC LIMIT 5 OFFSET 0
        I, [2017-12-31T18:52:23.418187 #57531]  INFO -- : Completed 200 OK in 5ms (Views: 0.1ms | ActiveRecord: 0.9ms)
        I, [2017-12-31T18:52:23.418611 #57531]  INFO -- : source=rack-timeout id=1e8539043ad3edb145b4c6e6d6b90ce7 timeout=280000000000ms service=11ms state=completed
        D, [2017-12-31T18:52:23.426091 #57530] DEBUG -- :   Account Load (12.1ms)  SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = 864 LIMIT 1
        D, [2017-12-31T18:52:23.429031 #57530] DEBUG -- :    (0.4ms)  SELECT COUNT(*) FROM `notifications` WHERE `notifications`.`account_id` = 864 AND (read_at IS NULL)
        I, [2017-12-31T18:52:23.429654 #57530]  INFO -- : Completed 200 OK in 17ms (Views: 0.1ms | ActiveRecord: 12.5ms)
      EOH
      aggregater = SugoiLogWatcher::Aggregater.new
      log.split("\n").each { |l| aggregater.add(l) }
      aggregater.aggregate
      expect(aggregater.complated.size).to eq(2)
      # pid はrequest に集約されること
      aggregater.complated.each { |request| expect(request.logs.map(&:pid).uniq).to eq([nil]) }
      expect(aggregater.complated.map(&:pid)).to match_array([57531, 57530])
      # 別セッションのmesasgeが入ってこないこと
      aggregater.complated.each { |request| expect(request.logs.first.type).to eq(:start) }
      aggregater.complated.each { |request| expect(request.logs.last.type).to eq(:end) }

      lines_57530 = <<~EOH
        I, [2017-12-31T18:52:23.409787 #57530]  INFO -- : Started GET "/api/a/accounts/864/notifications/status" for ::1 at 2017-12-31 18:52:23 +0900
        I, [2017-12-31T18:52:23.412411 #57530]  INFO -- : Processing by Internal::Albatross::Account::NotificationsController#status as JSON
        I, [2017-12-31T18:52:23.412665 #57530]  INFO -- :   Parameters: {"account_id"=>"864"}
        D, [2017-12-31T18:52:23.426091 #57530] DEBUG -- :   Account Load (12.1ms)  SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = 864 LIMIT 1
        D, [2017-12-31T18:52:23.429031 #57530] DEBUG -- :    (0.4ms)  SELECT COUNT(*) FROM `notifications` WHERE `notifications`.`account_id` = 864 AND (read_at IS NULL)
        I, [2017-12-31T18:52:23.429654 #57530]  INFO -- : Completed 200 OK in 17ms (Views: 0.1ms | ActiveRecord: 12.5ms)
      EOH
      expect(aggregater.complated.find { |x| x.pid == 57530 }.logs.map(&:raw_data).join("\n")).to eq(lines_57530.strip)
      lines_57531 = <<~EOH
        I, [2017-12-31T18:52:23.408871 #57531]  INFO -- : Started GET "/api/a/accounts/864/notifications?need_render=summary&page_size=5&type=unread" for ::1 at 2017-12-31 18:52:23 +0900
        I, [2017-12-31T18:52:23.412544 #57531]  INFO -- : Processing by Internal::Albatross::Account::NotificationsController#index as JSON
        I, [2017-12-31T18:52:23.412764 #57531]  INFO -- :   Parameters: {"need_render"=>"summary", "page_size"=>"5", "type"=>"unread", "account_id"=>"864"}
        D, [2017-12-31T18:52:23.414671 #57531] DEBUG -- :   Account Load (0.3ms)  SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = 864 LIMIT 1
        D, [2017-12-31T18:52:23.417662 #57531] DEBUG -- :   Notification Load (0.6ms)  SELECT  `notifications`.* FROM `notifications` WHERE `notifications`.`account_id` = 864 AND (read_at IS NULL) ORDER BY created_at DESC LIMIT 5 OFFSET 0
        I, [2017-12-31T18:52:23.418187 #57531]  INFO -- : Completed 200 OK in 5ms (Views: 0.1ms | ActiveRecord: 0.9ms)
      EOH

      expect(aggregater.complated.find { |x| x.pid == 57531 }.logs.map(&:raw_data).join("\n")).to eq(lines_57531.strip)
      expect(aggregater.complated.map.map{|x| x.logs.find_all{ |y| y.is_a?(SugoiLogWatcher::ParsedObject::SQL) } }.flatten.map(&:sql).sort).to eq(
        ["SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = N LIMIT N",
         "SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = N LIMIT N",
         "SELECT  `notifications`.* FROM `notifications` WHERE `notifications`.`account_id` = N AND (read_at IS NULL) ORDER BY created_at DESC LIMIT N OFFSET N"].sort
      )
      aggregater.complated.each do |request|
        expect(request.count_sql_calls["SELECT  `accounts`.* FROM `accounts` WHERE `accounts`.`id` = N LIMIT N"]).to eq(1)
      end
    end
  end
end
