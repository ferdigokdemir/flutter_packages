# 📦 Easy Update

A Remote Config based Flutter app version control package. Provides ready-to-use dialogs and services for mandatory and optional updates.

## ✨ Features

- ✅ **Semantic Versioning** - Correct version comparison (major.minor.patch)
- ✅ **Force Update** - Force users to update the app
- ✅ **Optional Update** - Dialog with "Later" option
- ✅ **Skip Version** - Users can skip a specific version
- ✅ **47 Languages** - Built-in multi-language support
- ✅ **Platform Aware** - Automatic iOS/Android store URLs

## 📋 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_update: ^1.0.0
```

## 🚀 Usage

### Basic Usage (Singleton)

```dart
import 'package:easy_update/easy_update.dart';

// 1️⃣ Initialize at app startup
await EasyUpdate.instance.init(
  android: EasyUpdatePlatformConfig(
    version: remoteConfig.getString('MIN_VERSION_ANDROID'),
    storeUrl: 'https://play.google.com/store/apps/details?id=...',
    force: remoteConfig.getBool('FORCE_UPDATE_ANDROID'),
    locale: 'en',
  ),
  ios: EasyUpdatePlatformConfig(
    version: remoteConfig.getString('MIN_VERSION_IOS'),
    storeUrl: 'https://apps.apple.com/app/...',
    force: remoteConfig.getBool('FORCE_UPDATE_IOS'),
    locale: 'en',
  ),
);

// 2️⃣ Check and show dialog
final status = await EasyUpdate.instance.check();

if (status.updateRequired) {
  await EasyUpdate.instance.showUpdateDialog(context);
}
```

### Widget Usage (EasyUpdateGate)

```dart
import 'package:easy_update/easy_update.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyUpdateGate(
      android: EasyUpdatePlatformConfig(
        version: '2.0.0',
        storeUrl: 'https://play.google.com/store/apps/details?id=...',
        force: true,
        locale: 'en',
      ),
      ios: EasyUpdatePlatformConfig(
        version: '2.1.0',
        storeUrl: 'https://apps.apple.com/app/...',
        force: false,
        locale: 'en',
      ),
      child: MaterialApp(...),
      // Optional: Create your own update screen
      updateBuilder: (context, status) => CustomUpdateScreen(status: status),
    );
  }
}
```

### Direct Dialog Usage

```dart
import 'package:easy_update/easy_update.dart';

showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => UpdateRequiredDialog(
    force: true,
    storeUrl: 'https://play.google.com/store/apps/details?id=...',
    locale: 'en',
    onUpdate: () => print('Opening store...'),
    onLater: () => print('User postponed'),
  ),
);
```

## 🔧 Remote Config Parameters

Define these parameters in Firebase Console or your own backend:

| Parameter | Type | Example | Description |
|-----------|------|---------|-------------|
| `MIN_VERSION_ANDROID` | String | `"2.0.0"` | Android minimum version |
| `MIN_VERSION_IOS` | String | `"2.1.0"` | iOS minimum version |
| `FORCE_UPDATE_ANDROID` | Bool | `true` | Is Android update mandatory? |
| `FORCE_UPDATE_IOS` | Bool | `false` | Is iOS update mandatory? |
| `STORE_URL_ANDROID` | String | `"https://play.google.com/..."` | Play Store link |
| `STORE_URL_IOS` | String | `"https://apps.apple.com/..."` | App Store link |

## 🎯 EasyUpdatePlatformConfig

```dart
class EasyUpdatePlatformConfig {
  final String version;    // Minimum required version
  final String storeUrl;   // Store URL
  final bool force;        // Is update mandatory? (default: false)
  final String locale;     // Dialog language (default: 'en')

  const EasyUpdatePlatformConfig({
    required this.version,
    required this.storeUrl,
    this.force = false,
    this.locale = 'en',
  });
}
```

## 📊 VersionCheckStatus

```dart
class VersionCheckStatus {
  final bool updateRequired;    // Is update required?
  final bool force;             // Is it mandatory? (true = no "Later" button)
  final String storeUrl;        // Store link
  final String currentVersion;  // Current version (e.g., "1.8.0")
  final String version;         // Required minimum (e.g., "2.0.0")
}
```

## 🌍 Supported Languages (47)

| Code | Language | Code | Language | Code | Language |
|------|----------|------|----------|------|----------|
| `al` | Albanian | `hu` | Hungarian | `pt` | Portuguese |
| `ar` | Arabic | `hi` | Hindi | `ro` | Romanian |
| `bn` | Bangla | `id` | Indonesian | `ru` | Russian |
| `bs` | Bosnian | `it` | Italian | `sk` | Slovak |
| `bg` | Bulgarian | `ja` | Japanese | `sl` | Slovenian |
| `ca` | Catalan | `ku` | Kurdish | `es` | Spanish |
| `zh` | Chinese | `ko` | Korean | `sw` | Swahili |
| `hr` | Croatian | `km` | Khmer | `se` | Swedish |
| `cs` | Czech | `lo` | Lao | `ta` | Tamil |
| `da` | Danish | `lv` | Latvian | `th` | Thai |
| `nl` | Dutch | `ms` | Malay | `tr` | Turkish |
| `en` | English | `mn` | Mongolian | `uk` | Ukrainian |
| `et` | Estonian | `no` | Norwegian | `vi` | Vietnamese |
| `fi` | Finnish | `pl` | Polish | | |
| `fa` | Farsi | `ka` | Georgian | | |
| `fr` | French | `de` | German | | |
| `el` | Greek | `he` | Hebrew | | |

### Language Usage

```dart
// Singleton - different language per platform
await EasyUpdate.instance.init(
  android: EasyUpdatePlatformConfig(
    version: '2.0.0',
    storeUrl: '...',
    force: true,
    locale: 'ja', // Japanese
  ),
  ios: EasyUpdatePlatformConfig(
    version: '2.1.0',
    storeUrl: '...',
    force: false,
    locale: 'en', // English
  ),
);

// With dialog
UpdateRequiredDialog(
  force: true,
  storeUrl: '...',
  locale: 'ko', // Korean
);

// Direct localization access
final l10n = EasyUpdateLocalizations.of('de');
print(l10n.updateButton); // "Aktualisieren"
```

## 🔄 Flow Diagram

```
┌─────────────────────────────────────────┐
│              APP STARTUP                │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  Get values from Remote Config:         │
│  • MIN_VERSION: "2.0.0"                 │
│  • FORCE_UPDATE: true/false             │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  currentVersion < MIN_VERSION ?         │
└─────────────────────────────────────────┘
          │                    │
         NO                   YES
          │                    │
          ▼                    ▼
   ┌────────────┐    ┌─────────────────────┐
   │ Continue   │    │ FORCE_UPDATE == true?│
   └────────────┘    └─────────────────────┘
                           │           │
                         YES          NO
                           │           │
                           ▼           ▼
                   ┌───────────┐ ┌─────────────┐
                   │ MANDATORY │ │ OPTIONAL    │
                   │ DIALOG    │ │ DIALOG      │
                   │           │ │             │
                   │ [Update]  │ │ [Update]    │
                   │           │ │ [Later]     │
                   └───────────┘ └─────────────┘
```

## 📝 Example: Check in TabsPage

```dart
class TabsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUpdate());
  }

  Future<void> _checkUpdate() async {
    try {
      final status = await EasyUpdate.instance.check();
      
      if (status.updateRequired) {
        await EasyUpdate.instance.showUpdateDialog(Get.context!);
      }
    } catch (e) {
      debugPrint('Version check error: $e');
    }
  }
}
```

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.
