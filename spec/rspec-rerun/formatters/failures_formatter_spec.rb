require 'spec_helper'
require 'stringio'

describe RSpec::Rerun::Formatters::FailuresFormatter do
  let(:output) { StringIO.new }
  let(:formatter) { RSpec::Rerun::Formatters::FailuresFormatter.new(output) }
  let(:example) { RSpec::Core::ExampleGroup.describe.example 'test' }
  let(:failures_file) { RSpec::Rerun::Formatters::FailuresFormatter::FILENAME }

  before { FileUtils.rm(failures_file) if File.exist?(failures_file) }
  after  { FileUtils.rm(failures_file) if File.exist?(failures_file) }
  after { formatter.clean! }

  describe 'example_passed' do
    it 'should not create an rspec.failures file' do
      formatter.example_passed(example)
      formatter.dump_failures
      expect(File.exist?(failures_file)).to eq false
    end
  end

  describe 'example_failed' do
    it 'should create an rspec.failures file' do
      formatter.example_failed(example)
      formatter.dump_failures
      expect(File.exist?(failures_file)).to eq true
      expect(File.read(failures_file).strip).to eq example.location
    end

    it 'should create one line per failed example' do
      2.times { formatter.example_failed(example) }
      formatter.dump_failures
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
