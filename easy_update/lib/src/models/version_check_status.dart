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
