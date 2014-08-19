require 'rspec/core'
require 'rspec-rerun/rspec'

if RSpec::Rerun.rspec3?
  begin
    require 'rspec/legacy_formatters'
  rescue LoadError => e
    STDERR.puts '*' * 80
    STDERR.puts e.message
    STDERR.puts 'Please add rspec-legacy_formatters to your Gemfile.'
    STDERR.puts 'See https://github.com/dblock/rspec-rerun/pull/22 for details.'
    STDERR.puts '*' * 80
    raise
  end
end

require 'rspec/core/formatters/base_formatter'

module RSpec
  module Rerun
    module Formatters
      class FailuresFormatter < RSpec::Core::Formatters::BaseFormatter
        FILENAME = 'rspec.failures'

        def dump_failures
          return if failed_examples.empty?
          f = File.new(FILENAME, 'w+')
          failed_examples.each do |example|
            f.puts retry_command(example)
          end
          f.close
        end

        def retry_command(example)
          example.location.gsub("\"", "\\\"")
        end

        def clean!
          File.delete FILENAME if File.exist? FILENAME
        end
      end
    end
  end
end
