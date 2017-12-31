require 'spec_helper'

RSpec.describe SugoiLogWatcher::Aggregater do
  let(:single_log) do
    <<~EOH
      I, [2017-12-26T00:01:52.910919 #36002]  INFO -- : Processing by WelcomeController#index as HTML
      I, [2017-12-26T00:01:52.910984 #36002]  INFO -- :   Parameters: {"locale"=>"ja"}
      I, [2017-12-26T00:01:52.927847 #36002]  INFO -- :   Rendering welcome/index.html.haml within layouts/welcome
      I, [2017-12-26T00:01:53.115696 #36002]  INFO -- :   Rendered welcome/_cambanner.html.haml (142.0ms)
      I, [2017-12-26T00:01:53.205907 #36002]  INFO -- :   Rendered welcome/ner.html.haml (3.0ms)
      I, [2017-12-26T00:01:53.250664 #36002]  INFO -- :   Rendered welcome/_priist.html.haml (43.1ms)
      I, [2017-12-26T00:01:53.256200 #36002]  INFO -- :   Rendered welcome/_stet.html.haml (3.8ms)
      I, [2017-12-26T00:01:53.260360 #36002]  INFO -- :   Rendered welcome/_conn_buttons.html.haml (2.5ms)
      I, [2017-12-26T00:01:53.274551 #36002]  INFO -- :   Rendered welcome/_newom.html.haml (12.7ms)
      I, [2017-12-26T00:01:53.283143 #36002]  INFO -- :   Rendered welcome/index.html.haml within layouts/welcome (355.1ms)
      I, [2017-12-26T00:01:53.304500 #36002]  INFO -- :   Rendered shared/_google_tag_manager.html.haml (3.4ms)
      D, [2017-12-26T00:01:53.560890 #36002] DEBUG -- : source=rack-timeout id=1b32e744ab93e1fbbb84135f88d11ce1 timeout=28000ms service=2014ms state=active
      D, [2017-12-26T00:01:54.556938 #36002] DEBUG -- : source=rack-timeout id=1b32e744ab93e1fbbb84135f88d11ce1 timeout=28000ms service=3010ms state=active
      D, [2017-12-26T00:01:55.553579 #36002] DEBUG -- : source=rack-timeout id=1b32e744ab93e1fbbb84135f88d11ce1 timeout=28000ms service=4006ms state=active
      D, [2017-12-26T00:01:56.556649 #36002] DEBUG -- : source=rack-timeout id=1b32e744ab93e1fbbb84135f88d11ce1 timeout=28000ms service=5009ms state=active
      I, [2017-12-26T00:01:57.403712 #36002]  INFO -- :   Rendered shared/_e.html.haml (3.1ms)
      D, [2017-12-26T00:01:57.554118 #36002] DEBUG -- : source=rack-timeout id=1b32e744ab93e1fbbb84135f88d11ce1 timeout=28000ms service=6007ms state=active
      I, [2017-12-26T00:01:58.149344 #36002]  INFO -- :   Rendered layouts/_airbrake_js.html.haml (1.7ms)
      I, [2017-12-26T00:01:58.153637 #36002]  INFO -- :   Rendered layouts/_rem.ja.html.haml (2.9ms)
      I, [2017-12-26T00:01:58.157245 #36002]  INFO -- :   Rendered shared/_olark.html.haml (2.2ms)
      I, [2017-12-26T00:01:58.160268 #36002]  INFO -- :   Rendered shared/_vwo.html.haml (1.4ms)
      I, [2017-12-26T00:01:58.161598 #36002]  INFO -- :   Rendered shared/_gr.html.haml (0.0ms)
      I, [2017-12-26T00:01:58.165296 #36002]  INFO -- :   Rendered shared/_fde.html.haml (2.3ms)
      I, [2017-12-26T00:01:58.178089 #36002]  INFO -- :   Rendered layouts/_topbar.html.haml (11.3ms)
      I, [2017-12-26T00:01:58.213485 #36002]  INFO -- :   Rendered layouts/__list.html.haml (20.9ms)
      I, [2017-12-26T00:01:58.214094 #36002]  INFO -- :   Rendered layouts/_.html.haml (34.6ms)
      I, [2017-12-26T00:01:58.222729 #36002]  INFO -- :   Rendered layouts/_s.html.haml (6.8ms)
      I, [2017-12-26T00:01:58.270726 #36002]  INFO -- :   Rendered layouts/_tent.html.haml (46.4ms)
      I, [2017-12-26T00:01:58.276706 #36002]  INFO -- :   Rendered layouts/_html.haml (3.8ms)
      I, [2017-12-26T00:01:58.283101 #36002]  INFO -- :   Rendered layouts/gg_html.haml (3.7ms)
      I, [2017-12-26T00:01:58.289100 #36002]  INFO -- :   Rendered shared/_yanager.html.haml (4.3ms)
      I, [2017-12-26T00:01:58.290110 #36002]  INFO -- : Completed 200 OK in 5379ms (Views: 5367.3ms | ActiveRecord: 0.0ms)
    EOH
  end

  it '集計すること' do
    aggregater = SugoiLogWatcher::Aggregater.new
    single_log.split("\n").each { |l| aggregater.add(l) }
    aggregater.aggregate
    expect(aggregater.complated.size).to eq(1)
  end
end
