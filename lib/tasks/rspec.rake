require 'rspec/core/rake_task'

desc "Run RSpec examples."
RSpec::Core::RakeTask.new("rspec-rerun:run") do |t|
  t.pattern = ENV['RSPEC_RERUN_PATTERN'] if ENV['RSPEC_RERUN_PATTERN']
  if ENV['RSPEC_NODE_TOTAL'] && ENV['RSPEC_NODE_INDEX']
    node_total = (ENV['RSPEC_NODE_TOTAL'] || 1).to_i
    node_index = (ENV['RSPEC_NODE_INDEX'] || 0).to_i

    all_files = FileList[t.pattern]

    # Deterministically shuffle tests so slow specs are evenly distributed among nodes
    rand = Random.new(1)
    all_files.shuffle!(random: rand) unless ENV['RSPEC_PARALLEL_RANDOMIZATION'] == 'false'

    slice_size = (all_files.size/(node_total.to_f)).ceil
    sliced_files = all_files.each_slice(slice_size).to_a
    t.pattern = sliced_files[node_index]
  end

  t.fail_on_error = false
  t.rspec_opts = [
    "--require", File.join(File.dirname(__FILE__), '../rspec-rerun'),
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.exist?(".rspec") ? File.read(".rspec").split(/\n+/).map { |l| l.shellsplit } : nil
  ].flatten
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
