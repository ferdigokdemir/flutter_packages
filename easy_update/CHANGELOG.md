# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.3] - 2026-06-24

### Changed

- `UpdateRequiredDialog` now uses a solid white background.
- Optional-update title shortened to "App Update" ("Uygulama Güncelleme") across all 47 languages.
- "Later" button relabeled to "Remind Me Later" ("Daha Sonra Hatırlat") across all 47 languages.

## [1.3.2] - 2026-06-21

### Added

- `UpdateBanner.borderRadius` — customizable corner radius (defaults to `BorderRadius.zero`); banner clips its content/ripple to the given radius.

## [1.3.1] - 2026-06-21

### Changed

- `UpdateBanner.backgroundColor` is now optional; when omitted the color reflects urgency — `pinkAccent` for mandatory updates (`status.force == true`), `amber` for optional ones. Pass an explicit color to override.

## [1.3.0] - 2026-06-21

### Added

- `UpdateBanner` — thin, non-dismissable inline update banner widget (icon + message + update action). Message switches on `status.force`; colors are customizable via constructor params. Tapping the strip or action opens the store URL.
- `EasyUpdateLocalizations.bannerMessage` — short, action-oriented message for optional-update banners ("Update the app to discover new features!").
- `EasyUpdateLocalizations.bannerForceMessage` — message for mandatory-update banners ("This version is no longer supported."). Both keys localized for `en`, `de`, `es`, `id`, `it`, `pt`, `tr`; other locales fall back to English.

## [1.2.1] - 2026-04-30

### Changed

- README improvements: updated example to use `run()`, removed Advanced Usage section

## [1.2.0] - 2026-04-30

### Added

- `EasyUpdate.instance.run(context, {android, ios})` — single-call API that initializes, checks version, and shows dialog if needed

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
