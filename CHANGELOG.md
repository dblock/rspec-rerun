Next Release
------------

* Your contribution here.

0.1.3
-----

* [#10](https://github.com/dblock/rspec-rerun/pull/10): Add optional `retry_count` argument to `rspec-rerun:spec` - [@mzikherman](https://github.com/mzikherman), [@dblock](https://github.com/dblock).
* Added support for `RSPEC_RERUN_RETRY_COUNT` and `RSPEC_RERUN_PATTERN` environment variables - [@dblock](https://github.com/dblock).
* Report failed count and log rake task retry messages to `$stderr` - [@dblock](https://github.com/dblock).

0.1.2
-----

* Fix failed `rake rspec-rerun:rerun` being falsely reported as success - [@jonleighton](https://github.com/jonleighton).
* [#9](https://github.com/dblock/rspec-rerun/pull/9): Added test for the `rspec-rerun:spec` Rake task - [@errm](https://github.com/errm).

0.1.1
-----

* Added logo - [@dblock](https://github.com/dblock).
* [#1](https://github.com/dblock/rspec-rerun/issues/1): Require `rspec/core/rake_task` explicitly in `rspec.rake` - [@dblock](https://github.com/dblock), [@TylerRick](https://github.com/TylerRick).

0.1.0
-----

* Initial public release, including `RSpec::Rerun::Formatters::FailuresFormatter` and the `rspec-rerun:run`, `rspec-rerun:rerun`, and `rspec-rerun:spec` Rake tasks - [@dblock](https://github.com/dblock).
