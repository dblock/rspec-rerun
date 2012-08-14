rspec-rerun [![Build Status](https://secure.travis-ci.org/dblock/rspec-rerun.png)](http://travis-ci.org/dblock/rspec-rerun)
===========

![rspec-rerun](https://raw.github.com/dblock/rspec-rerun/master/rspec-rerun.png)

The **rspec-rerun** gem is a drop-in solution to retry (rerun) failed RSpec examples. It may be useful, for example, with finnicky Capybara tests. The strategy to rerun failed specs is to output a file called `rspec.failures` that contains a list of failed examples and to feed that file back to RSpec via `-e`. 

Usage
-----

Add `rspec-rerun` to `Gemfile` in the `:development` and `:test` groups.

``` ruby
group :development, :test do
  gem "rspec-rerun"
end
```

Require `rspec-rerun` and change the default task in `Rakefile`.

``` ruby
require 'rspec-rerun'
task :default => "rspec-rerun:spec"
```

Run `rake` or `rake rspec-rerun:spec`. Failed examples will be rerun automatically.

It might also be a good idea to add `rspec.failures` to `.gitignore`.

History
-------

Rerunning failed specs has been a long requested feature [#456](https://github.com/rspec/rspec-core/issues/456) in [RSpec](https://github.com/rspec/rspec-core/). A viable approach was suggested in [#596](https://github.com/rspec/rspec-core/pull/596). The infrastructure from that pull request was merged and released with rspec-core 2.11, which enabled re-running specs outside of RSpec, as described in [our blog post](http://artsy.github.com/blog/2012/05/15/how-to-organize-over-3000-rspec-specs-and-retry-test-failures/). The **rspec-rerun** is a drop-in solution that has evolved from it. 

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](https://github.com/dblock/rspec-rerun/blob/master/LICENSE.md) for details.

(c) 2012 [Art.sy Inc.](http://artsy.github.com), [Daniel Doubrovkine](https://github.com/dblock) and [Contributors](https://github.com/dblock/rspec-rerun/blob/master/CHANGELOG.md)

