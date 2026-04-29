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
  easy_update: ^1.2.0
```

## 🚀 Usage

### Simple Usage — `run()`

One call does everything: initializes, checks the version, and shows the dialog if needed.

```dart
import 'package:easy_update/easy_update.dart';

await EasyUpdate.instance.run(
  context,
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
);
```

### Advanced Usage — Manual Steps

Use this when you need to inspect the status before showing the dialog.

```dart
import 'package:easy_update/easy_update.dart';

// 1️⃣ Initialize
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

// 2️⃣ Check
final status = await EasyUpdate.instance.check();

// 3️⃣ Show dialog
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

## 💡 Example: `run()` in Home Screen

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUpdate());
  }

  Future<void> _checkUpdate() async {
    try {
      final status = await EasyUpdate.instance.check();

      if (status.updateRequired && mounted) {
        await EasyUpdate.instance.showUpdateDialog(context);
      }
    } catch (e) {
      debugPrint('Version check error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}
```

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.
