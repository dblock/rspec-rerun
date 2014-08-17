require 'spec_helper'

describe 'RakeTask' do
  let(:root) { File.join(File.dirname(__FILE__), '../../..') }
  before :each do
    @filename = File.join(root, 'fail_once.state')
    File.open @filename, 'w' do |f|
      f.write 'fail'
    end
  end

  around :each do |example|
    silence_stream STDOUT do
      Dir.mktmpdir do |dir|
        ENV['HOME'] = dir
        example.run
      end
    end
    FileUtils.rm_f @filename
  end

  it 'succeeds' do
    system! "cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec"
  end

  it 'retries a spec failure once' do
    system! "cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_once_spec.rb rake rspec-rerun:spec"
  end

  it 'retries a spec failure twice' do
    system! "cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec[2]"
  end

  it 'retries a spec failure via RSPEC_RERUN_RETRY_COUNT' do
    system! "cd #{root} && RSPEC_RERUN_RETRY_COUNT=2 RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec[2]"
  end

  it 'does not retry via RSPEC_RERUN_RETRY_COUNT=0' do
    expect do
      system! "cd #{root} && RSPEC_RERUN_RETRY_COUNT=0 RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_once_spec.rb rake rspec-rerun:spec"
    end.to raise_error RuntimeError, /failed with exit code 1/
  end

  it 'fails with one too few retry counts' do
    expect do
      system! "cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec"
    end.to raise_error RuntimeError, /failed with exit code 1/
  end

  it 'fails with one too few retry counts set via RSPEC_RERUN_RETRY_COUNT' do
    expect do
      system! "cd #{root} && RSPEC_RERUN_RETRY_COUNT=1 RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec"
    end.to raise_error RuntimeError, /failed with exit code 1/
  end

  context 'preserving .rspec' do
    let(:dot_rspec) { "#{root}/.rspec" }
    let(:home_rspec) { File.expand_path('~/.rspec') }
    let(:run) { `cd #{root} && RSPEC_RERUN_RETRY_COUNT=1 RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec 2>&1` }

    around :each do |test|
      begin
        old = File.read(dot_rspec)
        File.unlink(dot_rspec)
        test.call
      ensure
        File.write(dot_rspec, old)
      end
    end

    it 'also uses progress if there is not .rspec' do
      run.should include '--format progress'
    end

    it 'also uses progress if formatter is not given' do
      File.write(dot_rspec, '--color')
      run.should include '--format progress'
    end

    it 'also uses given formatter' do
      File.write(dot_rspec, "--color\n--format documentation")
      run.should include '--format documentation'
    end

    it 'also uses given formatter from home' do
      File.write(File.expand_path('~/.rspec'), "--color\n--format documentation")
      run.should include '--format documentation'
    end
  end
end
