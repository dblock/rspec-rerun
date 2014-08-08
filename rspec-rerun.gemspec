$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'rspec-rerun/version'

Gem::Specification.new do |s|
  s.name = 'rspec-rerun'
  s.version = RSpec::Rerun::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.summary = 'Re-run failed RSpec tests.'
  s.email = 'dblock@dblock.org'
  s.homepage = 'http://github.com/dblock/rspec-rerun'
  s.rubygems_version = '1.8.25'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(/^(spec)\//)

  s.add_runtime_dependency 'rspec', '>= 2.11.0', '< 3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop', '0.24.1'
end
