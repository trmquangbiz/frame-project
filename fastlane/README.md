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

For app signing.
Please create 2 private repo to contains key for development (1 repository) and production (1 repository)

### ios testflight_beta

```sh
[bundle exec] fastlane ios testflight_beta
```

For developer to upload testflight.
Developer need to provide iCloud email and password and must have role in the App Store Connect team so they can upload beta build to Testflight

### ios testflight_beta_jenkin

```sh
[bundle exec] fastlane ios testflight_beta_jenkin
```

For jenkin CD to upload testflight.
Please create 1 private repository name 'app_store_connect_api_key' and contains the App Store Connect API Key. Every time jenkin run, after checking out, please redirect to fastlane directory and checkout the repository so it can insert the app store connect API Key

### ios distribute_firebase

```sh
[bundle exec] fastlane ios distribute_firebase
```

For ios distribution to firebase.
Need GoogleService-Info.plist to process. Developer need to run 'firebase login' first to provide credential

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
