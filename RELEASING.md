Releasing RSpec-Rerun
=====================

### Prepare

Make sure tests are green on [Travis CI](https://travis-ci.org/dblock/rspec-rerun).

```
rake bump:minor # to release major features or breaking API changes
rake bump:bump # to release bug fixes and/or very minor features
```

 - Change "Next" in [CHANGELOG.md](CHANGELOG.md) to this new version.
 - Move "Your contribution here." to a new empty "Next" section
 - Amend these changes to the bump commit `git commit -a --amend --no-edit`

### Release

```
rake release
```
