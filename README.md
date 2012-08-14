RSpec-Rerun [![Build Status](https://secure.travis-ci.org/dblock/rspec-rerun.png)](http://travis-ci.org/dblock/rspec-rerun)
===========

The strategy to rerun failed specs is to output a file called `rspec.failures` that contains a list of failed examples and to feed that file back to RSpec. 

Usage
-----

Add the `FailuresFormatter` to RSpec. One way to do this is to implement an `rspec:run` task in `lib/tasks/rspec.rake`.

``` ruby
RSpec::Core::RakeTask.new("rspec:run") do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
  t.fail_on_error = false
  t.spec_opts = [
    "--format", "RSpec::Rerun::Formatters::FailuresFormatter",
    File.read(File.join(Rails.root, ".rspec")).split(/\n+/).map { |l| l.shellsplit }
  ].flatten
end
```

Add a rerun task.

``` ruby
RSpec::Core::RakeTask.new("rspec:rerun") do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
  t.fail_on_error = false
  t.spec_opts = [
    "-O", File.join(Rails.root, 'rspec.failures'),
    File.read(File.join(Rails.root, '.rspec')).split(/\n+/).map { |l| l.shellsplit }
  ].flatten
end
```

Combine the two tasks.

``` ruby
task "test" do
  rspec_failures = File.join(Rails.root, 'rspec.failures')
  FileUtils.rm_f rspec_failures
  Rake::Task["rspec:run"].execute
  unless $?.success?
    puts "[#{Time.now}] Failed, rerunning #{File.read(rspec_failures).split(/\n+/).count} failure(s) ..."
    Rake::Task["spec:rerun"].execute
  end
end
```

History
-------

Rerunning failed specs has been a long requested feature in RSpec (see [#456](https://github.com/rspec/rspec-core/issues/456)). A viable approach has been finally implemented by [Matt Mitchell](https://github.com/antifun) in [#596](https://github.com/rspec/rspec-core/pull/596). The infrastructure from that pull request was released with RSpec 2.11, which made rerunning specs finally possible outside of RSpec, described in [this blog post](http://artsy.github.com/blog/2012/05/15/how-to-organize-over-3000-rspec-specs-and-retry-test-failures/).

The *rspec-rerun* gem is an attempt to package the parts that didn't make it into rspec-core.

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](https://github.com/dblock/rspec-rerun/blob/master/LICENSE.md) for details.

(c) 2012 [Art.sy Inc.](http://artsy.github.com), [Daniel Doubrovkine](https://github.com/dblock) and [Contributors](https://github.com/dblock/rspec-rerun/blob/master/CHANGELOG.md)

