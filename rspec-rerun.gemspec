require './lib/rspec-rerun/version'

Gem::Specification.new do |s|
  s.name = 'rspec-rerun'
  s.version = RSpec::Rerun::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.summary = 'Re-run failed RSpec tests.'
  s.email = 'dblock@dblock.org'
  s.homepage = 'https://github.com/dblock/rspec-rerun'
  s.license = 'MIT'
  s.files = `git ls-files lib README.md`.split($INPUT_RECORD_SEPARATOR)

  s.add_runtime_dependency 'rspec', '~> 3.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop', '0.31.0'
  s.add_development_dependency 'bump'
end
