require 'rubygems'
require 'bundler'

libdir = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'rspec-rerun'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rspec-rerun"
  gem.homepage = "http://github.com/dblock/rspec-rerun"
  gem.license = "MIT"
  gem.summary = "Re-run failed RSpec tests."
  gem.description = "Re-run failed RSpec tests."
  gem.email = "dblock@dblock.org"
  gem.version = RSpec::Rerun::VERSION
  gem.authors = [ "Daniel Doubrovkine" ]
  gem.files = Dir.glob('lib/**/*')
end

Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'

task :default => "rspec-rerun:spec"
