require 'rspec/core'
require 'rspec/core/formatters'

module RSpec
  module Rerun
    class Formatter
      ::RSpec::Core::Formatters.register self, :dump_failures

      FILENAME = 'rspec.failures'

      def initialize(_); end

      def dump_failures(notification)
        if notification.failed_examples.empty?
          clean!
        else
          rerun_commands = notification.failed_examples.map { |e| retry_command(e) }
<<<<<<< HEAD
          rerun_commands_split = rerun_commands.map {|item| item.split(":")[0]}
          rerun_commands_split = rerun_commands_split.uniq
          File.write(FILENAME, rerun_commands_split.join("\n"))
=======
          File.write(FILENAME, rerun_commands.join("\n").split(':')[0])
>>>>>>> c09013d4987203dc600e30e380384b22c88f58b9
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
