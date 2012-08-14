require 'rspec/core/formatters/base_formatter'

module RSpec
  module Rerun
    module Formatters
      class FailuresFormatter < RSpec::Core::Formatters::BaseFormatter

      	FILENAME = "rspec.failures"

        def dump_failures
          return if failed_examples.empty?
          f = File.new(FILENAME, "w+")
          failed_examples.each do |example|
            f.puts retry_command(example)
          end
          f.close
        end

        def retry_command(example)
          example_name = example.full_description.gsub("\"", "\\\"")
          "-e \"#{example_name}\""
        end

        def clean!
    		  if File.exists? FILENAME
    		    File.delete FILENAME
    		  end
        end

      end
    end
  end
end
