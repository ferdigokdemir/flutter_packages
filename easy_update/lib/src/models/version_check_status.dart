/// 📋 Version Check Sonuç Modeli
///
/// Version check işleminin sonucunu içerir.
class VersionCheckStatus {
  /// Güncelleme yapılması gerekli mi?
  final bool updateRequired;

  /// Güncelleme zorunlu mu? (false ise "Daha sonra" seçeneği var)
  final bool forceUpdate;

  /// App Store / Google Play URL'si
  final String storeUrl;

  /// Şu anki uygulama versiyonu
  final String currentVersion;

  /// Minimum gerekli versiyon
  final String minimumVersion;

  VersionCheckStatus({
    required this.updateRequired,
    required this.forceUpdate,
    required this.storeUrl,
    required this.currentVersion,
    required this.minimumVersion,
  });

  @override
  String toString() =>
      '''VersionCheckStatus(
    updateRequired: $updateRequired,
    forceUpdate: $forceUpdate,
    currentVersion: $currentVersion,
    minimumVersion: $minimumVersion,
  )''';
}
