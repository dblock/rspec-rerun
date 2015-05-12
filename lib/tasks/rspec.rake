require 'rspec/core/rake_task'
require 'rspec-rerun/tasks'

desc 'Run RSpec examples.'
RSpec::Core::RakeTask.new('rspec-rerun:run') do |t, args|
  t.pattern = args[:pattern] if args[:pattern]
  t.fail_on_error = false
  t.verbose = false if args[:verbose] == false
  t.rspec_opts = RSpec::Rerun::Tasks.rspec_opts(args)
end

desc 'Re-run failed RSpec examples.'
RSpec::Core::RakeTask.new('rspec-rerun:rerun') do |t, args|
  failing_specs = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split

  t.pattern = args[:pattern] if args[:pattern]
  t.fail_on_error = false
  t.verbose = false if args[:verbose] == false
  t.rspec_opts =  RSpec::Rerun::Tasks.rspec_opts(args, failing_specs.join(' '))
end

desc 'Run RSpec code examples.'
task 'rspec-rerun:spec' do |_t, args|
  parsed_args = RSpec::Rerun::Tasks.parse_args(args)
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
