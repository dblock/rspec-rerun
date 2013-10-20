require 'spec_helper'

describe "RakeTask" do
  before :each do
    @root = File.join(File.dirname(__FILE__), "../../..")
    @filename = File.join(@root, "fail_once.state")
    File.open @filename, "w" do |f|
      f.write "fail"
    end
  end

  around :each do |example|
    silence_stream STDOUT do
      example.run
    end
    FileUtils.rm_f @filename
  end

  it "succeeds" do
    system! "cd #{@root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/succeeds_spec.rb rake rspec-rerun:spec"
  end

  it "retries a spec failure once" do
    system! "cd #{@root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_once_spec.rb rake rspec-rerun:spec"
  end

  it "retries a spec failure twice" do
    system! "cd #{@root} && RSPEC_RERUN_MARKER=#{@filename} RSPEC_RERUN_PATTERN=spec-runs/fails_twice_spec.rb rake rspec-rerun:spec[2]"
  end
end
