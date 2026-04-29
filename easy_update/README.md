# 📦 Easy Update

A Remote Config based Flutter app version control package. Provides ready-to-use dialogs and services for mandatory and optional updates.

## ✨ Features

- ✅ **Semantic Versioning** - Correct version comparison (major.minor.patch)
- ✅ **Force Update** - Force users to update the app
- ✅ **Optional Update** - Dialog with "Later" option
- ✅ **Skip Version** - Users can skip a specific version
- ✅ **47 Languages** - Built-in multi-language support
- ✅ **Platform Aware** - Automatic iOS/Android store URLs
- ✅ **MaterialApp Builder** - Drop-in `EasyUpdateWidget` for the `builder` parameter

## 📋 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_update: ^1.0.3
```

## 🚀 Usage

### Option 1: MaterialApp Builder (Recommended)

The simplest approach — add `EasyUpdateWidget` directly to `MaterialApp`'s `builder`. It automatically checks for updates on app launch and shows a dialog if needed.

```dart
import 'package:easy_update/easy_update.dart';
import 'package:flutter/material.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return EasyUpdateWidget(
          navigatorKey: _navigatorKey,
          android: EasyUpdatePlatformConfig(
            version: '2.0.0',
            storeUrl: 'https://play.google.com/store/apps/details?id=com.example.app',
            force: true,
            locale: 'en',
          ),
          ios: EasyUpdatePlatformConfig(
            version: '2.0.0',
            storeUrl: 'https://apps.apple.com/app/id123456789',
            force: true,
            locale: 'en',
          ),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
```

**Optional parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `navigatorKey` | `GlobalKey<NavigatorState>` | required | Shared with `MaterialApp` |
| `android` | `EasyUpdatePlatformConfig?` | `null` | Android config |
| `ios` | `EasyUpdatePlatformConfig?` | `null` | iOS config |
| `child` | `Widget` | required | The child widget from builder |
| `onException` | `Function(Object, StackTrace)?` | `null` | Error callback |
| `delayMilliseconds` | `int` | `0` | Delay before checking (ms) |

---

### Option 2: Basic Usage (Singleton)

```dart
import 'package:easy_update/easy_update.dart';

// 1️⃣ Initialize at app startup
await EasyUpdate.instance.init(
  android: EasyUpdatePlatformConfig(
    version: '2.0.0',
    storeUrl: 'https://play.google.com/store/apps/details?id=com.example.app',
    force: false,
    locale: 'en',
  ),
  ios: EasyUpdatePlatformConfig(
    version: '2.0.0',
    storeUrl: 'https://apps.apple.com/app/id123456789',
    force: false,
    locale: 'en',
  ),
);

// 2️⃣ Check and show dialog
final status = await EasyUpdate.instance.check();

if (status.updateRequired) {
  await EasyUpdate.instance.showUpdateDialog(context);
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

##  Example: Check in TabsPage

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
