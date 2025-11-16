# 📦 Easy Update

Remote Config tabanlı Flutter uygulama sürüm kontrol paketi. Zorunlu ve isteğe bağlı güncellemeler için hazır dialog ve service sağlar.

## ✨ Özellikler

- ✅ **Remote Config Entegrasyonu** - Firebase Remote Config ile sürüm yönetimi
- ✅ **Semantic Versioning** - Doğru sürüm karşılaştırması (major.minor.patch)
- ✅ **Zorunlu Güncelleme** - Kullanıcıyı zorla güncellemeye yönlendir
- ✅ **İsteğe Bağlı Güncelleme** - "Daha sonra" seçeneği sunan dialog
- ✅ **Native Back Button Desteği** - Zorunlu güncelleme sırasında back button'u blokla
- ✅ **GetX Entegrasyonu** - Get paketinin tüm özelliklerini kullanır

## 📋 Kurulum

`pubspec.yaml`'da ekle:

```yaml
dependencies:
  easy_update:
    path: packages/easy_update
```

## 🚀 Kullanım

### 1. Service'i Başlat

```dart
import 'package:easy_update/easy_update.dart';

// App başlangıcında - Remote Config'den version bilgisini al
await Get.putAsync<VersionCheckService>(
  () async => VersionCheckService(
    minimumVersion: remoteConfig.getString('MIN_VERSION'),
    forceUpdate: remoteConfig.getBool('FORCE_UPDATE'),
    storeUrl: remoteConfig.getString('GOOGLE_PLAY_URL'),
  ),
  permanent: true,
);
```

### 2. Version Kontrolünü Yapın

```dart
final versionCheckService = VersionCheckService.instance;
final status = await versionCheckService.checkForUpdates();

if (status.updateRequired) {
  await UpdateRequiredDialog.show(
    forceUpdate: status.forceUpdate,
    storeUrl: status.storeUrl,
  );
}
```

### 3. Remote Config Parametrelerini Ayarla

Firebase Console'da şu parametreleri tanımla:

```
MIN_VERSION: "1.7.8"
FORCE_UPDATE: false
GOOGLE_PLAY_URL: "https://play.google.com/store/apps/details?id=..."
APPLE_STORE_URL: "https://apps.apple.com/app/..."
```

## 📱 Örnek: TabsPage'de Kontrol

```dart
@override
void onInit() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final versionCheckService = VersionCheckService.instance;
      final status = await versionCheckService.checkForUpdates();
      
      if (status.updateRequired) {
        await UpdateRequiredDialog.show(
          forceUpdate: status.forceUpdate,
          storeUrl: status.storeUrl,
        );
      }
    } catch (e) {
      print('Version check error: $e');
    }
    
    init(); // Diğer initialization işlemleri
  });
  super.onInit();
}
```

## 🔍 VersionCheckStatus Modeli

```dart
class VersionCheckStatus {
  /// Güncelleme yapılması gerekli mi?
  final bool updateRequired;

  /// Güncelleme zorunlu mu?
  final bool forceUpdate;

  /// App Store / Google Play URL'si
  final String storeUrl;

  /// Şu anki uygulama versiyonu
  final String currentVersion;

  /// Minimum gerekli versiyon
  final String minimumVersion;
}
```

## 🧪 Test Senaryoları

| Senaryo | MIN_VERSION | FORCE_UPDATE | Beklenen Davranış |
|---------|-----------|--------------|-------------------|
| Güncelleme gerekli değil | "1.0.0" | false | Dialog gösterilmez |
| Güncelleme önerisi | "1.8.0" | false | "Daha sonra" butonu var |
| Zorunlu güncelleme | "9.9.9" | true | "Daha sonra" butonu YOK, back button bloke |

## 🎨 Dialog Özellikleri

- **Zorunlu Güncelleme (forceUpdate=true)**
  - ❌ Dialog dışa tıklanarak kapatılamaz
  - ❌ Native back button ile kapatılamaz
  - ❌ "Daha sonra" butonu gizli
  - ✅ Sadece "Şimdi Güncelle" butonu

- **İsteğe Bağlı Güncelleme (forceUpdate=false)**
  - ✅ Dialog dışa tıklanarak kapatılabilir
  - ✅ Native back button ile kapatılabilir
  - ✅ "Daha sonra" butonu görünür

## 📦 Bağımlılıklar

- `flutter`: ^3.0.0
- `get`: ^4.6.6
- `package_info_plus`: ^9.0.0
- `url_launcher`: ^6.3.1
- `firebase_remote_config`: ^6.0.0

## 📄 Lisans

MIT
