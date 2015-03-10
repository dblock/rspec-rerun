require 'rspec/core/rake_task'

desc 'Run RSpec examples.'
RSpec::Core::RakeTask.new('rspec-rerun:run') do |t, args|
  t.pattern = args[:pattern] if args[:pattern]
  t.fail_on_error = false
  t.verbose = false if args[:verbose] == false
  t.rspec_opts = rspec_opts(args)
end

desc 'Re-run failed RSpec examples.'
RSpec::Core::RakeTask.new('rspec-rerun:rerun') do |t, args|
  failing_specs = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split

  t.pattern = args[:pattern] if args[:pattern]
  t.fail_on_error = false
  t.verbose = false if args[:verbose] == false
  t.rspec_opts =  rspec_opts(args, failing_specs.join(' '))
end

desc 'Run RSpec code examples.'
task 'rspec-rerun:spec' do |_t, args|
  parsed_args = parse_args(args)
  retry_count = (parsed_args[:retry_count] || 1).to_i

  fail 'retry count must be >= 1' if retry_count <= 0
  FileUtils.rm_f RSpec::Rerun::Formatters::FailuresFormatter::FILENAME
  Rake::Task['rspec-rerun:run'].execute(parsed_args)
  while !$?.success? && retry_count > 0
    retry_count -= 1
    failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
    msg = "[#{Time.now}] Failed, re-running #{failed_count} failure#{failed_count == 1 ? '' : 's'}"
    msg += ", #{retry_count} #{retry_count == 1 ? 'retry' : 'retries'} left" if retry_count > 0
    $stderr.puts "#{msg} ..."
    Rake::Task['rspec-rerun:rerun'].execute(parsed_args)
  end
  unless $?.success?
    failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
    $stderr.puts "[#{Time.now}] #{failed_count} failure#{failed_count == 1 ? '' : 's'}."
    fail "#{failed_count} failure#{failed_count == 1 ? '' : 's'}"
  end
end

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
  opts[:tag] ||= ENV['RSPEC_RERUN_TAG'] if ENV['RSPEC_RERUN_PATTERN']
  opts[:retry_count] ||= ENV['RSPEC_RERUN_RETRY_COUNT'] if ENV['RSPEC_RERUN_RETRY_COUNT']
  opts[:verbose] = (ENV['RSPEC_RERUN_VERBOSE'] != 'false') if opts[:verbose].nil?

  opts
end
