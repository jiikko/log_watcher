require 'spec_helper'

RSpec.describe SugoiLogWatcher::QueryObject do
  it 'be success' do
    SugoiLogWatcher::QueryObject.new(pid: "36002", 
                                     path: "welcome/_conn_buttons.html.haml", 
                                     msec: "2.5", 
                                     raw_data: "I, [2017-12-26T00:01:53.260360 #36002]  INFO -- :   Rendered welcome/_conn_buttons.html.haml (2.5ms)")
  end
end
