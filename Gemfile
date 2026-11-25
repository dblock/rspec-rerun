source 'https://rubygems.org'

gemspec

version = ENV['RSPEC_VERSION'] || '~> 3.0'
gem 'rspec', version unless version == 'LATEST'

group :development, :test do
  if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
    gem 'rubocop', '~> 1.92'
    gem 'rubocop-md', '~> 3.0', require: false
    gem 'rubocop-prose', '~> 0.2', require: false
    gem 'rubocop-rake', '~> 0.7', require: false
    gem 'rubocop-spellcheck', '~> 0.2', require: false
    gem 'rubocop-yaml', '~> 0.1.0', require: false
  end
end

if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
  group :development do
    gem 'commonmarker', '~> 2.10', require: false
    gem 'ruby-gem-release', '0.9.0', require: false
  end
end
