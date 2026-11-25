require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec-rerun/tasks'
require 'bump/tasks'
require 'rspec/core/rake_task'

lint = Gem.loaded_specs.key?('rubocop')
if lint
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc 'Lint Ruby, Markdown, YAML, and spelling'
  task lint: :rubocop
end

task default: lint ? [:rubocop, 'rspec-rerun:spec'] : ['rspec-rerun:spec']
