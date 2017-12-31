require 'spec_helper'

RSpec.describe SugoiLogWatcher::Aggregater do
  let(:single_log) do
    <<~EOH
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
  end

  it '集計すること' do
    aggregater = SugoiLogWatcher::Aggregater.new
    single_log.split("\n").each { |l| aggregater.add(l) }
    aggregater.aggregate
    expect(aggregater.complated.size).to eq(1)
  end
end
