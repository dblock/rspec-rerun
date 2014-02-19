# -*- encoding: utf-8 -*-
# stub: rspec-rerun 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-rerun"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Doubrovkine"]
  s.date = "2013-11-19"
  s.description = "Re-run failed RSpec tests."
  s.email = "dblock@dblock.org"
  s.extra_rdoc_files = ["LICENSE.md", "README.md"]
  s.files = ["lib/rspec-rerun.rb", "lib/rspec-rerun/formatters/failures_formatter.rb", "lib/rspec-rerun/version.rb", "lib/tasks/rspec.rake", "LICENSE.md", "README.md"]
  s.homepage = "http://github.com/dblock/rspec-rerun"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "Re-run failed RSpec tests."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.11.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
