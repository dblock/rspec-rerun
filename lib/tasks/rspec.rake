require 'rspec/core/rake_task'

desc "Run RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:run") do |t|
  t.pattern = ENV['RSPEC_RERUN_PATTERN'] || "spec/**/*_spec.rb"
  t.rspec_opts = [
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
end

desc "Re-run failed RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:rerun") do |t|
  t.pattern = ENV['RSPEC_RERUN_PATTERN'] || "spec/**/*_spec.rb"
  t.rspec_opts = [
    "-O", RSpec::Rerun::Formatters::FailuresFormatter::FILENAME,
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
end

desc "Run RSpec code examples."
task "rspec-rerun:spec", :retry_count do |t, args|
  retry_count = (args[:retry_count] || 1).to_i
  FileUtils.rm_f RSpec::Rerun::Formatters::FailuresFormatter::FILENAME
  begin
    Rake::Task["rspec-rerun:run"].execute
  rescue SystemExit
    while retry_count > 0
      failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
      retry_count -= 1
      if retry_count > 0
        $stderr.puts "[#{Time.now}] Failed, re-running #{failed_count} failure(s), #{retry_count} #{retry_count == 1 ? 'retry' : 'retries'} left  ..."
      else
        $stderr.puts "[#{Time.now}] Failed, re-running #{failed_count} failure(s) ..."
      end
      begin
        Rake::Task["rspec-rerun:rerun"].execute
        break
      rescue SystemExit
      end
    end
  end
end
