module RSpec
  module Rerun
    module Tasks
      class << self
        def rspec_opts(args, spec_files = nil)
          opts = [
            spec_files,
            '--require', File.join(File.dirname(__FILE__), '../rspec-rerun'),
            '--format', 'RSpec::Rerun::Formatters::FailuresFormatter',
            *dot_rspec_params
          ].compact.flatten
          if args[:tag]
            opts << '--tag'
            opts << args[:tag]
          end
          opts
        end

        def parse_args(args)
          opts = args.extras

          # Error on multiple arguments
          if opts.size > 1
            fail ArgumentError 'rspec-rerun can take an integer (retry_count) or options hash'
          else
            opts = opts[0]
          end

          # Handle if opts is just a retry_count integer
          opts = if opts.is_a? Hash
                   opts
                 else
                   { retry_count: opts }
                 end

          # Parse environment variables
          opts[:pattern] ||= ENV['RSPEC_RERUN_PATTERN'] if ENV['RSPEC_RERUN_PATTERN']
          opts[:tag] ||= ENV['RSPEC_RERUN_TAG'] if ENV['RSPEC_RERUN_TAG']
          opts[:retry_count] ||= ENV['RSPEC_RERUN_RETRY_COUNT'] if ENV['RSPEC_RERUN_RETRY_COUNT']
          opts[:verbose] = (ENV['RSPEC_RERUN_VERBOSE'] != 'false') if opts[:verbose].nil?

          opts
        end

        private

        def dot_rspec_params
          dot_rspec_file = ['.rspec', File.expand_path('~/.rspec')].detect { |f| File.exist?(f) }
          dot_rspec = if dot_rspec_file
                        file_contents = File.read(dot_rspec_file)
                        file_contents.split(/\n+/).map(&:shellsplit).flatten
                      else
                        []
                      end
          dot_rspec.concat ['--format', 'progress'] unless dot_rspec.include?('--format')
          dot_rspec
        end
      end
    end
  end
end
