require 'spec_helper'

RSpec.describe SugoiLogWatcher::LineParser do
  it 'be success' do
    line = 'I, [2017-12-26T00:01:53.256200 #36002]  INFO -- :   Rendered welcome/_stet.html.haml (3.8ms)'
    actual = SugoiLogWatcher::LineParser.new(line).parse
    expect(actual).to be_a(SugoiLogWatcher::RenderingObject)
    expect(actual.path).to eq('welcome/_stet.html.haml')
    expect(actual.pid).to eq('36002')
    expect(actual.msec).to eq('3.8')
  end
end
