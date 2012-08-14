RSpec-Rerun [![Build Status](https://secure.travis-ci.org/dblock/rspec-rerun.png)](http://travis-ci.org/dblock/rspec-rerun)
===========

The strategy to rerun failed specs is to output a file called `rspec.failures` that contains a list of failed examples and to feed that file back to RSpec. 

Usage
-----

Add `rspec-rerun` to `Gemfile`.

``` ruby
gem "rspec-rerun"
```

Require `rspec-rerun` and change the default task in `Rakefile`.

``` ruby
require 'rspec-rerun'
task :default => "rspec-rerun:spec"
```

It might also be a good idea to add `rspec.failures` to `.gitignore`.

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

