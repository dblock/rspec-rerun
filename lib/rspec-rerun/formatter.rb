require 'rspec/core'
require 'rspec/legacy_formatters'
require 'rspec/core/formatters/base_formatter'

module RSpec
  module Rerun
    class Formatter < RSpec::Core::Formatters::BaseFormatter
      FILENAME = 'rspec.failures'

      def dump_failures
        if failed_examples.empty?
          clean!
        else
          rerun_commands = failed_examples.map { |e| retry_command(e) }
          File.write(FILENAME, rerun_commands.join("\n"))
        end
      end

      def clean!
        File.delete FILENAME if File.exist? FILENAME
      end

      private

      def retry_command(example)
        if example.respond_to?(:rerun_argument)
          example.rerun_argument
        else
          example.location.gsub("\"", "\\\"")
        end
      end
    end
  end
end
