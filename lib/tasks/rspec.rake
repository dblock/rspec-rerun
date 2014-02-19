require 'rspec/core/rake_task'

desc "Run RSpec examples."
task "rspec-rerun:run", :node_total, :node_index do |t, args|
  @rspec_path = 'rspec'
  @pattern    = './spec{,/*/**}/*_spec.rb'

  rspec_opts = [
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten

  all_files = FileList[ @pattern ].sort.map(&:shellescape)
  slice_size = (all_files.size/(args[:node_total].to_f)).ceil
  sliced_files = all_files.each_slice(slice_size).to_a
  files_to_run = sliced_files[args[:node_index]]

  cmd_parts = []
  cmd_parts << 'ruby'
  cmd_parts << "-S" << @rspec_path
  cmd_parts << files_to_run
  cmd_parts << rspec_opts
  command = cmd_parts.flatten.reject(&:blank?).join(" ")

  system(command)
end

desc "Re-run failed RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:rerun") do |t|
  t.pattern = ENV['RSPEC_RERUN_PATTERN'] if ENV['RSPEC_RERUN_PATTERN']
  t.fail_on_error = false
  t.rspec_opts = [
    "-O", RSpec::Rerun::Formatters::FailuresFormatter::FILENAME,
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
end

desc "Run RSpec code examples."
task "rspec-rerun:spec", :retry_count, :node_total, :node_index do |t, args|
  retry_count = (args[:retry_count] || ENV['RSPEC_RERUN_RETRY_COUNT'] || 1).to_i
  node_total = (args[:node_total] || 1).to_i
  node_index = (args[:node_index] || 0).to_i
  fail "retry count must be >= 1" if retry_count <= 0
  FileUtils.rm_f RSpec::Rerun::Formatters::FailuresFormatter::FILENAME
  Rake::Task["rspec-rerun:run"].execute(node_total: node_total, node_index: node_index)
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
