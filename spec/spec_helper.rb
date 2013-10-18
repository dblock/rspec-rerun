$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'rspec-rerun'

Dir[File.join(File.dirname(__FILE__), 'support/*.rb')].each do |file|
  require file
end
