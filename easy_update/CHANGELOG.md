# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-26

### Added

- Initial release
- `EasyUpdate` singleton for easy initialization and version checking
- `EasyUpdateGate` widget for declarative update blocking
- `UpdateRequiredDialog` for customizable update dialogs
- `VersionCheckService` for semantic version comparison
- Support for 47 languages with built-in localizations
- Platform-aware store URL handling (iOS/Android)
- Skip version feature - users can skip specific versions
- Force update mode for critical updates
- Optional update mode with "Later" option
- Shared preferences integration for storing skipped versions
