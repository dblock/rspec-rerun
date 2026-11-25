source 'https://rubygems.org'

gemspec

version = ENV['RSPEC_VERSION'] || '~> 3.0'
gem 'rspec', version unless version == 'LATEST'

group :development, :test do
  if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
    gem 'rubocop', '~> 1.92'
  end
end
