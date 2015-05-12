require 'spec_helper'

describe RSpec::Rerun do
  it 'has a version' do
    expect(RSpec::Rerun::VERSION).to_not be_nil
    expect(RSpec::Rerun::VERSION.to_f).to be > 0
  end
end
