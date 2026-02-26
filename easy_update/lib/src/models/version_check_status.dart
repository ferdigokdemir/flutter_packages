/// 🎯 Platform bazlı güncelleme konfigürasyonu.
///
/// Her platform için versiyon, store URL, force ve locale bilgilerini içerir.
///
/// **Örnek kullanım:**
/// ```dart
/// EasyUpdatePlatformConfig(
///   version: '2.0.0',
///   storeUrl: 'https://play.google.com/store/apps/details?id=...',
///   force: true,
///   locale: 'tr',
/// )
/// ```
class EasyUpdatePlatformConfig {
  /// Minimum gerekli versiyon (örn: "2.0.0", "1.5.3")
  ///
  /// Semantic versioning formatında olmalıdır: major.minor.patch
  final String version;

  /// Store URL (Play Store veya App Store linki)
  ///
  /// Örnek:
  /// - Android: `https://play.google.com/store/apps/details?id=com.example.app`
  /// - iOS: `https://apps.apple.com/app/id123456789`
  final String storeUrl;

  /// Zorunlu güncelleme mi?
  ///
  /// - `true`: Kullanıcı güncellemeyi atlayamaz, "Daha sonra" butonu gösterilmez
  /// - `false`: Kullanıcı "Daha sonra" seçebilir (varsayılan)
  final bool force;

  /// Dialog dili (ISO 639-1 kodu)
  ///
  /// Desteklenen diller: tr, en, de, es, fr, ja, ko, zh, ar, ru...
  /// Toplam 47 dil desteklenir. Varsayılan: 'en'
  final String locale;

  /// Platform bazlı güncelleme konfigürasyonu oluşturur.
  ///
  /// [version] ve [storeUrl] zorunludur.
  /// [force] varsayılan olarak `false`, [locale] varsayılan olarak `'en'` değerindedir.
  const EasyUpdatePlatformConfig({
    required this.version,
    required this.storeUrl,
    this.force = false,
    this.locale = 'en',
  });
}

/// 📋 Version Check Sonuç Modeli
///
/// Version check işleminin sonucunu içerir.
class VersionCheckStatus {
  /// Güncelleme yapılması gerekli mi?
  final bool updateRequired;

  /// Güncelleme zorunlu mu? (false ise "Daha sonra" seçeneği var)
  final bool force;

  /// App Store / Google Play URL'si
  final String storeUrl;

  /// Şu anki uygulama versiyonu
  final String currentVersion;

  /// Minimum gerekli versiyon
  final String version;

  VersionCheckStatus({
    required this.updateRequired,
    required this.force,
    required this.storeUrl,
    required this.currentVersion,
    required this.version,
  });

  @override
  String toString() =>
      '''VersionCheckStatus(
    updateRequired: $updateRequired,
    force: $force,
    currentVersion: $currentVersion,
    version: $version,
  )''';
}
