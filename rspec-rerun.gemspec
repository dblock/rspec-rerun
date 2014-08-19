require './lib/rspec-rerun/version'
require './lib/rspec-rerun/rspec'

Gem::Specification.new do |s|
  s.name = 'rspec-rerun'
  s.version = RSpec::Rerun::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.summary = 'Re-run failed RSpec tests.'
  s.email = 'dblock@dblock.org'
  s.homepage = 'https://github.com/dblock/rspec-rerun'
  s.license = 'MIT'
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(/^(spec)\//)

  s.add_runtime_dependency 'rspec'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop', '0.24.1'
end
