fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios signing

```sh
[bundle exec] fastlane ios signing
```

For app signing

### ios testflight_beta

```sh
[bundle exec] fastlane ios testflight_beta
```

For developer to upload testflight

### ios testflight_beta_jenkin

```sh
[bundle exec] fastlane ios testflight_beta_jenkin
```

For jenkin CD to upload testflight

### ios distribute_firebase

```sh
[bundle exec] fastlane ios distribute_firebase
```

For ios distribution to firebase

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
