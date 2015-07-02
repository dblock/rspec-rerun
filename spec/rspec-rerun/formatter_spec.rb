require 'spec_helper'
require 'stringio'
require 'rspec-rerun/formatter'

describe RSpec::Rerun::Formatter do
  let(:output) { StringIO.new }
  let(:formatter) { RSpec::Rerun::Formatter.new(output) }
  let(:example) { double('example', location: 'some/path.rb') }
  let(:examples_notification) { double('examples_notification', failed_examples: []) }
  let(:failures_file) { RSpec::Rerun::Formatter::FILENAME }

  before { formatter.clean! }
  after  { formatter.clean! }

  describe 'example_passed' do
    it 'should not create an rspec.failures file' do
      formatter.dump_failures(examples_notification)
      expect(File.exist?(failures_file)).to eq false
    end
  end

  describe 'example_failed' do
    it 'should create an rspec.failures file' do
      allow(examples_notification).to receive(:failed_examples) { [example] }
      formatter.dump_failures(examples_notification)
      expect(File.exist?(failures_file)).to eq true
      expect(File.read(failures_file).strip).to eq example.location
    end

    it 'should create one line per failed example' do
      allow(examples_notification).to receive(:failed_examples) { [example, example] }
      formatter.dump_failures(examples_notification)
      expect(File.exist?(failures_file)).to eq true
      expect(File.read(failures_file).split("\n")).to eq [example.location, example.location]
    end
  end

  describe 'clean!' do
    it "doesn't raise errors when the retry file doesn't exist" do
      expect { formatter.clean! }.to_not raise_error
    end

    it 'deletes the retry file' do
      File.open(failures_file, 'w+') do |f|
        f.puts 'test'
      end
      expect(File.exist?(failures_file)).to eq true
      formatter.clean!
      expect(File.exist?(failures_file)).to eq false
    end
  end
end
