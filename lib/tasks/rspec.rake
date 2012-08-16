require 'rspec/core/rake_task'

desc "Run RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:run") do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
  t.fail_on_error = false
  t.rspec_opts = [
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
end

desc "Re-run failed RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:rerun") do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
  t.fail_on_error = false
  t.rspec_opts = [
    "-O", RSpec::Rerun::Formatters::FailuresFormatter::FILENAME,
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
end

desc "Run RSpec code examples."
task "rspec-rerun:spec" do
  FileUtils.rm_f RSpec::Rerun::Formatters::FailuresFormatter::FILENAME
  Rake::Task["rspec-rerun:run"].execute
  unless $?.success?
    failed_count = File.read(RSpec::Rerun::Formatters::FailuresFormatter::FILENAME).split(/\n+/).count
    puts "[#{Time.now}] Failed, rerunning #{failed_count} failure(s) ..."
    Rake::Task["rspec-rerun:rerun"].execute
  end
end
