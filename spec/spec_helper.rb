$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'rake'
require 'rspec-rerun'
require 'tmpdir'

%w(support examples).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each do |file|
    require file
  end
end

if RSpec::Rerun.rspec3?
  RSpec.configure do |config|
    config.expect_with :rspec do |c|
      c.syntax = [:should, :expect]
    end
  end
end
