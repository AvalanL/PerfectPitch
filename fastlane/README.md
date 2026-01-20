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

### ios test

```sh
[bundle exec] fastlane ios test
```

Run all tests

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Push a new beta build to TestFlight

Options: build_number, changelog

### ios release

```sh
[bundle exec] fastlane ios release
```

Push a new release build to the App Store

Options: version (patch/minor/major), submit (true/false)

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Capture screenshots for all device sizes

### ios download_metadata

```sh
[bundle exec] fastlane ios download_metadata
```

Download metadata from App Store Connect

### ios upload_metadata

```sh
[bundle exec] fastlane ios upload_metadata
```

Upload metadata to App Store Connect

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload screenshots to App Store Connect

### ios bump

```sh
[bundle exec] fastlane ios bump
```

Bump version number

Options: type (patch/minor/major)

### ios version

```sh
[bundle exec] fastlane ios version
```

Get current version and build number

### ios clean

```sh
[bundle exec] fastlane ios clean
```

Clean build artifacts

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
