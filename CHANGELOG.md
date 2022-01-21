# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]



## [1.0.0] - 2022-01-21
### Added
- AES GCM encryption
- Fix invalid type cast
- Simpler log format
- String template for log output
- OutputLogFormat class for predefined log formats
- LogExporter class
- LogWidget for display all saved logs

### Changed
- Upgrade AndroidManifest.xml
- Upgrade dependencies
- Refactor DateTimeUtils
- Refactor LogStorage
- Refactor Constants and Enums
- Refactor project structure
- Refactor FlogDao class
- Refactor and cleanup FLog class
- Rewrite log filters
- DataLogType from String to Enum
- Rewrite functionality for export logs into text file
- Improve example project
- Replace Strings by Enums or Constants  

### Fixed
- Fix timestamp formats

### Removed
- Unused Constants and Enums
- Formatter class


