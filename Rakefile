require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec-rerun'
require 'bump/tasks'
require 'rspec/core/rake_task'

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:rubocop, 'rspec-rerun:spec']
