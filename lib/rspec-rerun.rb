require 'rspec-rerun/version'

require 'rspec-rerun/formatters/failures_formatter.rb'

if defined?(Rake)
  Dir[File.join(File.dirname(__FILE__), '../lib/tasks/**/*.rake')].each do |f|
    load f
  end
end
