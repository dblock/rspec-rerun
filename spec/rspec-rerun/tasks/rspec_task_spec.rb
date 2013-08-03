require 'rake'
require 'rspec-rerun'

describe "RakeTask" do
  let(:rake) { Rake.application }
  subject { rake["rspec-rerun:spec"] }

  before do
    rake.rake_require("tasks/rspec")
  end

  unless ENV['RSPEC_RERUN_SELF_TEST_PASS']
    it "fails if the specs fail" do
      if ENV['RSPEC_RERUN_SELF_TEST_FAIL']
        fail
      else
        begin
          ENV['RSPEC_RERUN_SELF_TEST_FAIL'] = "1"
          silence_stream(STDOUT) do
            subject.invoke
          end
        rescue SystemExit => e
          e.success?.should be_false
        ensure
          ENV['RSPEC_RERUN_SELF_TEST_FAIL'] = nil
        end
      end
    end
  end

  unless ENV['RSPEC_RERUN_SELF_TEST_FAIL']
    it "passes if the specs pass" do
      if ENV['RSPEC_RERUN_SELF_TEST_PASS']
        true.should be_true
      else
        begin
          ENV['RSPEC_RERUN_SELF_TEST_PASS'] = "1"
          silence_stream(STDOUT) do
            subject.invoke
          end
        rescue SystemExit => e
          e.success?.should be_true
        ensure 
          FileUtils.rm(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME)
          ENV['RSPEC_RERUN_SELF_TEST_PASS'] = nil
        end
      end
    end
  end
end

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen('/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end
