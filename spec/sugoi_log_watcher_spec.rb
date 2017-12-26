require "spec_helper"

RSpec.describe SugoiLogWatcher do
  it "has a version number" do
    expect(SugoiLogWatcher::VERSION).not_to be nil
  end
end
