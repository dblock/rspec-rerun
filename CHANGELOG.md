0.3.0 (Next)
------------

* [#22](https://github.com/dblock/rspec-rerun/pull/22): Added support for RSpec 3 - [@nightscape](https://github.com/nightscape), [@dblock](https://github.com/dblock).
* [#23](https://github.com/dblock/rspec-rerun/issues/23): Fixed dual formatter error - [@KurtPreston](https://github.com/KurtPreston).
* Allow disabling RSpec verbose output - [@KurtPreston](https://github.com/KurtPreston).
* Option to run on a specific tag - [@KurtPreston](https://github.com/KurtPreston).
* Your contribution here.

0.2.0
-----

* [#20](https://github.com/dblock/rspec-rerun/pull/20): Added support for ~/.rspec - [@grosser](https://github.com/grosser).
* [#14](https://github.com/dblock/rspec-rerun/issues/14), [#2](https://github.com/dblock/rspec-rerun/issues/2), [#19](https://github.com/dblock/rspec-rerun/pull/19): Additionally use progress or other formatter specified in .rspec - [@grosser](https://github.com/grosser).
* [#12](https://github.com/dblock/rspec-rerun/issues/12): Fixing execution of tests without names - [@KurtPreston](https://github.com/KurtPreston).
* Removed Jeweler and rewritten rspec-rerun.gemspec - [@dblock](https://github.com/dblock).
* Added Rubocop, Ruby-style linter - [@dblock](https://github.com/dblock).

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
