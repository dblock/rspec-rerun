require 'rspec/core/rake_task'

desc "Run RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:run") do |t|
  t.pattern = ENV['RSPEC_RERUN_PATTERN'] if ENV['RSPEC_RERUN_PATTERN']
  t.fail_on_error = false
  t.rspec_opts = [
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    *dot_rspec_params
  ].flatten
end

desc "Re-run failed RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:rerun") do |t|
  failing_specs = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split

  t.pattern = ENV['RSPEC_RERUN_PATTERN'] if ENV['RSPEC_RERUN_PATTERN']
  t.fail_on_error = false
  t.rspec_opts = [
    failing_specs.join(' '),
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    *dot_rspec_params
  ].flatten
end

desc "Run RSpec code examples."
task "rspec-rerun:spec", :retry_count do |t, args|
  retry_count = (args[:retry_count] || ENV['RSPEC_RERUN_RETRY_COUNT'] || 1).to_i
  fail "retry count must be >= 1" if retry_count <= 0
  FileUtils.rm_f RSpec::Rerun::Formatters::FailuresFormatter::FILENAME
  Rake::Task["rspec-rerun:run"].execute
  while !$?.success? && retry_count > 0
    retry_count -= 1
    failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
    msg = "[#{Time.now}] Failed, re-running #{failed_count} failure#{failed_count == 1 ? '' : 's'}"
    msg += ", #{retry_count} #{retry_count == 1 ? 'retry' : 'retries'} left" if retry_count > 0
    $stderr.puts "#{msg} ..."
    Rake::Task["rspec-rerun:rerun"].execute
  end
  if !$?.success?
    failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
    $stderr.puts "[#{Time.now}] #{failed_count} failure#{failed_count == 1 ? '' : 's'}."
    fail "#{failed_count} failure#{failed_count == 1 ? '' : 's'}"
  end
end

def dot_rspec_params
  dot_rspec_file = [".rspec", File.expand_path("~/.rspec")].detect { |f| File.exist?(f) }
  dot_rspec = if dot_rspec_file
                file_contents = File.read(dot_rspec_file)
                file_contents.split(/\n+/).map { |l| l.shellsplit }.flatten
              else
                []
              end
  dot_rspec.concat ["--format", "progress"] unless dot_rspec.include?("--format")
  dot_rspec
end
