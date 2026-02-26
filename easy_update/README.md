# 📦 Easy Update

Remote Config tabanlı Flutter uygulama sürüm kontrol paketi. Zorunlu ve isteğe bağlı güncellemeler için hazır dialog ve service sağlar.

## ✨ Özellikler

- ✅ **Semantic Versioning** - Doğru sürüm karşılaştırması (major.minor.patch)
- ✅ **Zorunlu Güncelleme** - Kullanıcıyı zorla güncellemeye yönlendir
- ✅ **İsteğe Bağlı Güncelleme** - "Daha sonra" seçeneği sunan dialog
- ✅ **Sürüm Atlama** - Kullanıcı belirli bir sürümü atlayabilir
- ✅ **47 Dil Desteği** - Çoklu dil desteği built-in
- ✅ **Platform Aware** - iOS/Android store URL'leri otomatik

## 📋 Kurulum

`pubspec.yaml` dosyasına ekle:

```yaml
dependencies:
  easy_update:
    path: packages/easy_update
```

## 🚀 Kullanım

### Temel Kullanım (Singleton)

```dart
import 'package:easy_update/easy_update.dart';

// 1️⃣ App başlangıcında init et
await EasyUpdate.instance.init(
  android: EasyUpdatePlatformConfig(
    version: remoteConfig.getString('MIN_VERSION_ANDROID'),
    storeUrl: 'https://play.google.com/store/apps/details?id=...',
    force: remoteConfig.getBool('FORCE_UPDATE_ANDROID'),
    locale: 'tr',
  ),
  ios: EasyUpdatePlatformConfig(
    version: remoteConfig.getString('MIN_VERSION_IOS'),
    storeUrl: 'https://apps.apple.com/app/...',
    force: remoteConfig.getBool('FORCE_UPDATE_IOS'),
    locale: 'tr',
  ),
);

// 2️⃣ Kontrol et ve dialog göster
final status = await EasyUpdate.instance.check();

if (status.updateRequired) {
  await EasyUpdate.instance.showUpdateDialog(context);
}
```

### Widget Kullanımı (EasyUpdateGate)

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
        locale: 'tr',
      ),
      ios: EasyUpdatePlatformConfig(
        version: '2.1.0',
        storeUrl: 'https://apps.apple.com/app/...',
        force: false,
        locale: 'en',
      ),
      child: MaterialApp(...),
      // Opsiyonel: Kendi güncelleme ekranınızı oluşturun
      updateBuilder: (context, status) => CustomUpdateScreen(status: status),
    );
  }
}
```

### Direkt Dialog Kullanımı

```dart
import 'package:easy_update/easy_update.dart';

showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => UpdateRequiredDialog(
    force: true,
    storeUrl: 'https://play.google.com/store/apps/details?id=...',
    locale: 'tr',
    onUpdate: () => print('Store açılıyor...'),
    onLater: () => print('Kullanıcı erteledi'),
  ),
);
```

## 🔧 Remote Config Parametreleri

Firebase Console veya kendi backend'inizde şu parametreleri tanımlayın:

| Parametre | Tip | Örnek | Açıklama |
|-----------|-----|-------|----------|
| `MIN_VERSION_ANDROID` | String | `"2.0.0"` | Android minimum versiyon |
| `MIN_VERSION_IOS` | String | `"2.1.0"` | iOS minimum versiyon |
| `FORCE_UPDATE_ANDROID` | Bool | `true` | Android zorunlu güncelleme mi? |
| `FORCE_UPDATE_IOS` | Bool | `false` | iOS zorunlu güncelleme mi? |
| `STORE_URL_ANDROID` | String | `"https://play.google.com/..."` | Play Store linki |
| `STORE_URL_IOS` | String | `"https://apps.apple.com/..."` | App Store linki |

## 🎯 EasyUpdatePlatformConfig

```dart
class EasyUpdatePlatformConfig {
  final String version;    // Minimum gerekli versiyon
  final String storeUrl;   // Store URL
  final bool force;        // Zorunlu güncelleme mi? (varsayılan: false)
  final String locale;     // Dialog dili (varsayılan: 'en')

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
  final bool updateRequired;    // Güncelleme gerekli mi?
  final bool force;             // Zorunlu mu? (true = "Daha sonra" yok)
  final String storeUrl;        // Store linki
  final String currentVersion;  // Mevcut versiyon (ör: "1.8.0")
  final String version;         // Gerekli minimum (ör: "2.0.0")
}
```

## 🌍 Desteklenen Diller (47)

| Kod | Dil | Kod | Dil | Kod | Dil |
|-----|-----|-----|-----|-----|-----|
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

### Dil Kullanımı

```dart
// Singleton ile - her platform için farklı dil
await EasyUpdate.instance.init(
  android: EasyUpdatePlatformConfig(
    version: '2.0.0',
    storeUrl: '...',
    force: true,
    locale: 'ja', // Japonca
  ),
  ios: EasyUpdatePlatformConfig(
    version: '2.1.0',
    storeUrl: '...',
    force: false,
    locale: 'en', // İngilizce
  ),
);

// Dialog ile
UpdateRequiredDialog(
  force: true,
  storeUrl: '...',
  locale: 'ko', // Korece
);

// Direkt localization erişimi
final l10n = EasyUpdateLocalizations.of('de');
print(l10n.updateButton); // "Aktualisieren"
```

## 🔄 Akış Diyagramı

```
┌─────────────────────────────────────────┐
│            APP BAŞLANGIÇ                │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  Remote Config'den değerleri al:        │
│  • MIN_VERSION: "2.0.0"                 │
│  • FORCE_UPDATE: true/false             │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  currentVersion < MIN_VERSION ?         │
└─────────────────────────────────────────┘
          │                    │
        HAYIR                EVET
          │                    │
          ▼                    ▼
   ┌────────────┐    ┌─────────────────────┐
   │ Devam et   │    │ FORCE_UPDATE == true?│
   └────────────┘    └─────────────────────┘
                           │           │
                         EVET        HAYIR
                           │           │
                           ▼           ▼
                   ┌───────────┐ ┌─────────────┐
                   │ ZORUNLU   │ │ OPSİYONEL   │
                   │ DIALOG    │ │ DIALOG      │
                   │           │ │             │
                   │ [Güncelle]│ │ [Güncelle]  │
                   │           │ │ [Daha Sonra]│
                   └───────────┘ └─────────────┘
```

## 📝 Örnek: TabsPage'de Kontrol

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

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.
