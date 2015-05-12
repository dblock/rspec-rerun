require 'bundler/setup'
require 'rspec-rerun'
require 'tmpdir'

RSpec.configure do |config|
  config.include(Module.new do
    def silence_stream(stream)
      old_stream = stream.dup
      stream.reopen('/dev/null')
      stream.sync = true
      yield
    ensure
      stream.reopen(old_stream)
    end

    def system!(cmd)
      fail "failed with exit code #{$?.exitstatus}" unless system(cmd)
    end
  end)
end
