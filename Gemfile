source 'http://rubygems.org'

gemspec

case rspec_version = ENV['RSPEC_VERSION'] || '~> 3.0'
when /2/
  gem 'rspec', '~> 2.11'
when /3/
  gem 'rspec', '~> 3.0'
  gem 'rspec-legacy_formatters'
else
  gem 'rspec', rspec_version
end
