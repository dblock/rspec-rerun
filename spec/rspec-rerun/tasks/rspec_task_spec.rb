require 'spec_helper'

describe 'RakeTask' do
  let(:root) { Bundler.root }
  before :each do
    @filename = File.join(root, 'fail_once.state')
    File.write @filename, 'fail'
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

  context 'verbose output' do
    it 'displays the rspec command by default' do
      expect(`cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec`).to include('rspec')
    end

    context 'when the RSPEC_RERUN_VERBOSE flag is set to false' do
      it "doesn't display the rspec command" do
        result = `cd #{root} && RSPEC_RERUN_VERBOSE=false RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec`
        expect(result).not_to include('rspec')
      end
    end
  end

  context 'tag execution' do
    it 'does not scope by tag by default' do
      expect(`cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec`).not_to include('--tag')
    end

    context 'when the RSPEC_RERUN_TAG flag is set' do
      it 'scopes rspec to the tag' do
        expect(`cd #{root} && RSPEC_RERUN_TAG=test RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec`).to include('--tag test')
      end
    end
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

    it 'does not pass a formatter if there is no .rspec' do
      expect(run).not_to include '--format'
      expect(run).to include 'Failed, 1 failure'
    end

    it 'does not pass a formatter if .rspec does not give one' do
      File.write(dot_rspec, '--color')
      expect(run).not_to include '--format'
    end

    it 'only uses the formatter specified by the .rspec file' do
      File.write(dot_rspec, '--format documentation')
      expect(run).to include '--format documentation'
      expect(run).not_to include '--format progress'
    end

    it 'honors a default formatter set in RSpec.configure' do
      result = `cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_once_spec.rb SPEC_OPTS="--require ./spec-runs/support/default_formatter" rake rspec-rerun:spec 2>&1`
      expect($?).to be_success
      expect(result).to include 'once (FAILED - 1)'
    end

    it 'also uses given formatter' do
      File.write(dot_rspec, "--color\n--format documentation")
      expect(run).to include '--format documentation'
    end

    it 'also uses given formatter from home' do
      File.write(File.expand_path('~/.rspec'), "--color\n--format documentation")
      expect(run).to include '--format documentation'
    end
  end

  context 'failures outside of examples' do
    it 'fails without re-running and explains why' do
      result = `cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_outside_examples_spec.rb rake rspec-rerun:spec 2>&1`
      expect($?).not_to be_success
      expect(result).to include 'without recording failed examples in rspec.failures, so there is nothing to re-run'
      expect(result).not_to include 'deliberately-left-blank'
      expect(result).not_to include 'Errno::ENOENT'
    end
  end

  context 'formatters in SPEC_OPTS' do
    it 'retries a spec failure' do
      result = `cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_once_spec.rb SPEC_OPTS="--format documentation" rake rspec-rerun:spec 2>&1`
      expect($?).to be_success
      expect(result).to include 'once (FAILED - 1)'
      expect(result).to include '1 example, 0 failures'
    end
  end

  context 'ignoring pattern during rerun' do
    let(:run) { `cd #{root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec 2>&1` }

    it 'also uses progress if there is not .rspec' do
      expect(run).to include '--pattern deliberately-left-blank'
    end
  end
end
