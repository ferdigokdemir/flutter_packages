# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-04-30

### Removed

- `EasyUpdateWidget` removed. Use `EasyUpdate.instance` singleton instead.

## [1.1.0] - 2026-04-30

### Added

- `EasyUpdateWidget` — drop-in widget for `MaterialApp`'s `builder` parameter
- Automatic version check on first frame after app launch
- `navigatorKey` based dialog presentation (no `BuildContext` required)
- `delayMilliseconds` parameter to delay the version check
- `onException` callback for error handling in `EasyUpdateWidget`

## [1.0.2] - 2026-02-27

## [1.0.1] - 2026-02-27

### Changed

- Renamed `PlatformConfig` to `EasyUpdatePlatformConfig` for better naming convention
- Translated README to English
- Updated documentation with class-based API examples

## [1.0.0] - 2026-02-26

### Added

- Initial release
- `EasyUpdate` singleton for easy initialization and version checking
- `UpdateRequiredDialog` for customizable update dialogs
- `VersionCheckService` for semantic version comparison
- Support for 47 languages with built-in localizations
- Platform-aware store URL handling (iOS/Android)
- Skip version feature - users can skip specific versions
- Force update mode for critical updates
- Optional update mode with "Later" option
- Shared preferences integration for storing skipped versions
