require 'spec_helper'

describe "Fails" do
  it "once" do
    filename = ENV['RSPEC_RERUN_MARKER']
    if File.exists? filename
      File.delete filename
      fail
    else
      true.should be_true
    end
  end
end
