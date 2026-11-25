# frozen_string_literal: true

require 'rspec/core'
require 'rspec-rerun/formatter'

# Records failing examples with RSpec::Rerun::Formatter without passing it with --format, so that formatters given in
# SPEC_OPTS and a default_formatter set in RSpec.configure keep working. RSpec adds its default formatter only when no
# formatter was given, and --format in SPEC_OPTS replaces the formatters on the command line.
RSpec.configure do |config|
  config.before(:suite) do
    config.add_formatter(RSpec::Rerun::Formatter) unless config.formatters.any?(RSpec::Rerun::Formatter)
  end
end
