require 'spec_helper'

describe 'Fails' do
  it 'once' do
    filename = ENV['RSPEC_RERUN_MARKER']
    if File.exist? filename
      File.delete filename
      fail
    else
      expect(true).to eq true
    end
  end
end
