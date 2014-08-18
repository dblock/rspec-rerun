require 'rubygems'
require 'bundler'

libdir = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'rspec-rerun'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, 'rspec-rerun:spec']
