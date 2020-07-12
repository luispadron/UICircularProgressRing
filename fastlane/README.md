fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### create_project
```
fastlane create_project
```
Creates the project file
### lint
```
fastlane lint
```
Runs swiftlint
### run_snapshot
```
fastlane run_snapshot
```
Run snapshot generation
### test
```
fastlane test
```
Run Xcode tests, including snapshot tests
### ci_test
```
fastlane ci_test
```
Runs all steps required for CI
### gen_docs
```
fastlane gen_docs
```
Runs Jazzy documentation generation

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
