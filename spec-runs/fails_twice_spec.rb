require 'spec_helper'

describe 'Fails' do
  it 'twice' do
    filename_once = ENV['RSPEC_RERUN_MARKER']
    filename_twice = File.join(File.dirname(filename_once), 'fail_twice.state')
    if File.exist? filename_once
      File.delete filename_once
      File.open filename_twice, 'w' do |f|
        f.write 'fail'
      end
      fail
    elsif File.exist? filename_twice
      File.delete filename_twice
      fail
    else
      expect(true).to eq true
    end
  end
end
