require 'spec_helper'

describe RSpec::Rerun do
  it "has a version" do
    RSpec::Rerun::VERSION.should_not be_nil
    RSpec::Rerun::VERSION.to_f.should > 0
  end
end
