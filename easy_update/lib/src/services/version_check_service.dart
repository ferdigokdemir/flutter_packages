import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/version_check_status.dart';

/// 📦 Version Check Service
///
/// Uygulamanın güncel olup olmadığını kontrol eder.
/// Minimum sürüm dışardan verilir, Remote Config'ten alınmaz.
///
/// **Kullanım:**
/// ```dart
/// final service = VersionCheckService(
///   minimumVersion: '1.7.8',
///   forceUpdate: true,
///   storeUrl: 'https://play.google.com/store/apps/details?id=...',
/// );
/// final status = await service.checkForUpdates();
///
/// if (status.updateRequired) {
///   UpdateRequiredDialog.show(
///     forceUpdate: status.forceUpdate,
///     storeUrl: status.storeUrl,
///   );
/// }
/// ```

class VersionCheckService {
  /// Minimum gerekli versiyon
  final String minimumVersion;

  /// Güncelleme zorunlu mu?
  final bool forceUpdate;

  /// App Store / Google Play URL'si
  final String storeUrl;

  VersionCheckService({
    required this.minimumVersion,
    required this.forceUpdate,
    required this.storeUrl,
  });

  /// 🔍 Sürüm güncelleme kontrolü
  ///
  /// Mevcut uygulama sürümünü kurucuda verilen minimum versiyon ile karşılaştırır.
  /// Güncellemeler varsa, zorunlu olup olmadığını belirler.
  ///
  /// Returns:
  /// - `updateRequired` - Güncelleme yapılması gerekli mi?
  /// - `forceUpdate` - Güncelleme zorunlu mu? (true ise kullanıcı devam edemez)
  /// - `storeUrl` - App Store / Google Play URL'si
  /// - `currentVersion` - Şu anki uygulama versiyonu
  /// - `minimumVersion` - Minimum gerekli versiyon
  ///
  /// **Örnek Sonuç:**
  /// ```dart
  /// VersionCheckStatus(
  ///   updateRequired: true,
  ///   forceUpdate: false,
  ///   storeUrl: "https://play.google.com/store/apps/details?id=...",
  ///   currentVersion: "1.7.8",
  ///   minimumVersion: "1.8.0",
  /// )
  /// ```
  Future<VersionCheckStatus> checkForUpdates() async {
    try {
      // 📦 Mevcut uygulama sürümü
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // ⚖️ Sürüm karşılaştırması
      final updateRequired = _isUpdateRequired(
        currentVersion: currentVersion,
        minimumVersion: minimumVersion,
      );

      return VersionCheckStatus(
        updateRequired: updateRequired,
        forceUpdate: updateRequired && forceUpdate,
        storeUrl: storeUrl,
        currentVersion: currentVersion,
        minimumVersion: minimumVersion,
      );
    } catch (e) {
      debugPrint('❌ [EasyUpdate] Error: $e');
      // Hata durumunda güvenli davran
      return VersionCheckStatus(
        updateRequired: false,
        forceUpdate: false,
        storeUrl: '',
        currentVersion: '0.0.0',
        minimumVersion: '0.0.0',
      );
    }
  }

  /// 🔢 Sürüm karşılaştırması
  ///
  /// Semantic versioning ile iki sürümü karşılaştırır.
  /// Format: "major.minor.patch" (örn: "1.7.8")
  ///
  /// true döndürürse: currentVersion < minimumVersion (güncelleme gerekli)
  ///
  /// **Örnekler:**
  /// - `_isUpdateRequired("1.7.8", "1.8.0")` → true (1.7.8 < 1.8.0)
  /// - `_isUpdateRequired("1.8.0", "1.8.0")` → false (eşit)
  /// - `_isUpdateRequired("2.0.0", "1.8.0")` → false (daha yeni)
  /// - `_isUpdateRequired("1.7.5", "1.7.8")` → true (patch daha eski)
  bool _isUpdateRequired({
    required String currentVersion,
    required String minimumVersion,
  }) {
    try {
      final current = _parseVersion(currentVersion);
      final minimum = _parseVersion(minimumVersion);

      // Major sürüm karşılaştırması
      if (current['major'] != minimum['major']) {
        return current['major']! < minimum['major']!;
      }

      // Minor sürüm karşılaştırması
      if (current['minor'] != minimum['minor']) {
        return current['minor']! < minimum['minor']!;
      }

      // Patch sürüm karşılaştırması
      return current['patch']! < minimum['patch']!;
    } catch (e) {
      return false;
    }
  }

  /// 🔨 Sürüm strini parse et
  ///
  /// "1.7.8" → {"major": 1, "minor": 7, "patch": 8}
  Map<String, int> _parseVersion(String version) {
    try {
      final parts = version.split('.');

      return {
        'major': int.tryParse(parts.elementAtOrNull(0) ?? '0') ?? 0,
        'minor': int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0,
        'patch': int.tryParse(parts.elementAtOrNull(2) ?? '0') ?? 0,
      };
    } catch (e) {
      return {'major': 0, 'minor': 0, 'patch': 0};
    }
  }
}
