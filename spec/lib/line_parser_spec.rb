require 'spec_helper'

RSpec.describe SugoiLogWatcher::LineParser do
  it 'be success' do
    line = 'I, [2017-12-26T00:01:53.256200 #36002]  INFO -- :   Rendered welcome/_stet.html.haml (3.8ms)'
    actual = SugoiLogWatcher::LineParser.new(line).parse
    expect(actual.render_path).to eq('welcome/_stet.html.haml')
    expect(actual.pid).to eq('36002')
    expect(actual.msec).to eq('3.8')
    expect(actual.type).to eq(:message)

    line = 'I, [2017-12-31T17:17:43.078024 #52408]  INFO -- : Started POST "/login" for 127.0.0.1 at 2017-12-31 17:17:43 +0900'
    actual = SugoiLogWatcher::LineParser.new(line).parse
    expect(actual.type).to eq(:start)

    line = "I, [2017-12-31T17:17:43.080320 #52408]  INFO -- : Processing by SessionController#create as HTML"
    actual = SugoiLogWatcher::LineParser.new(line).parse
    expect(actual.type).to eq(:message)

    line = 'I, [2017-12-31T17:17:43.080393 #52408]  INFO -- :   Parameters: {"utf8"=>"✓", "authenticity_token"=>"XHy9TVK+", "path"=>"", "email"=>"sample@sample.com", "password"=>"[FILTERED]", "commit"=>"ログイン"}'
    actual = SugoiLogWatcher::LineParser.new(line).parse
    expect(actual.type).to eq(:message)
  end
end
