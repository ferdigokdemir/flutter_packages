import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 💾 Easy Cache Service - SharedPreferences tabanlı önbellekleme
///
/// **Özellikler:**
/// - TTL (Time To Live) desteği - otomatik süre dolumu
/// - JSON serialization/deserialization
/// - Bulk operations (setMultiple, getMultiple)
/// - Cache istatistikleri ve temizleme
/// - Expired cache otomatik temizleme
///
/// **Kullanım:**
/// ```dart
/// // Initialize
/// await EasyCacheService.instance.init();
///
/// // Veri kaydet (7 gün)
/// await EasyCacheService.instance.set(
///   key: 'user_123',
///   data: {'name': 'John', 'age': 30},
///   duration: Duration(days: 7).inSeconds,
/// );
///
/// // Veri getir
/// final cachedUser = await EasyCacheService.instance.get(key: 'user_123');
/// if (cachedUser != null) {
///   print('Cached: $cachedUser');
/// }
/// ```
///
/// ⚠️ **Best Practices:**
/// - Cache key'leri için prefix kullanın: 'user_', 'fortune_', etc.
/// - Kritik veriler için cache kullanmayın (auth tokens, etc.)
/// - Büyük veriler için compression düşünün
/// - Periyodik olarak `clearExpired()` çağırın
class EasyCacheService {
  // � Singleton instance
  EasyCacheService._();
  static final EasyCacheService instance = EasyCacheService._();

  // �📦 SharedPreferences instance cache (performans için)
  SharedPreferences? _prefs;

  /// SharedPreferences instance'ı al (cache'lenmiş)
  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// ✅ Service'i initialize et
  Future<void> init() async {
    // SharedPreferences'i hazırla
    await _preferences;
  }

  /// ✅ Veriyi önbelleğe kaydeder
  ///
  /// [key] - Cache anahtarı (prefix kullanın: 'user_', 'fortune_')
  /// [data] - JSON serialize edilebilir veri
  /// [duration] - TTL saniye cinsinden
  ///
  /// **Örnek:**
  /// ```dart
  /// await cache.set(
  ///   key: 'user_${userId}',
  ///   data: user.toJson(),
  ///   duration: Duration(days: 7).inSeconds,
  /// );
  /// ```
  Future<bool> set({
    required String key,
    required dynamic data,
    required int duration,
  }) async {
    try {
      final prefs = await _preferences;
      final expiryKey = '${key}_expiry';

      // JSON encode
      final jsonData = jsonEncode(data);

      // TTL hesapla (saniye cinsinden depolamak daha verimli)
      final expiryTime = DateTime.now()
              .add(Duration(seconds: duration))
              .millisecondsSinceEpoch ~/
          1000;

      // Atomik write - her ikisini de kaydet
      await Future.wait([
        prefs.setString(key, jsonData),
        prefs.setInt(expiryKey, expiryTime),
      ]);

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.set error: $e\n$stackTrace');
      return false;
    }
  }

  /// 🔍 Önbellekten veri getir
  ///
  /// TTL kontrolü yapar, expired ise otomatik temizler ve null döner.
  ///
  /// **Örnek:**
  /// ```dart
  /// final cached = await cache.get(key: 'user_123');
  /// if (cached != null) {
  ///   return UserModel.fromJson(cached);
  /// }
  /// // Cache miss - API'den getir
  /// ```
  Future<dynamic> get({required String key}) async {
    try {
      final prefs = await _preferences;
      final expiryKey = '${key}_expiry';

      // TTL kontrolü
      final expiryTime = prefs.getInt(expiryKey);
      if (expiryTime == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (now > expiryTime) {
        // ⏰ Expired - otomatik temizle
        await Future.wait([prefs.remove(key), prefs.remove(expiryKey)]);
        return null;
      }

      // 📦 Veriyi getir ve decode et
      final jsonData = prefs.getString(key);
      return jsonData != null ? jsonDecode(jsonData) : null;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.get error: $e\n$stackTrace');
      return null;
    }
  }

  /// 🗑️ Cache girdisini temizle
  Future<bool> remove({required String key}) async {
    try {
      final prefs = await _preferences;
      await Future.wait([prefs.remove(key), prefs.remove('${key}_expiry')]);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.remove error: $e\n$stackTrace');
      return false;
    }
  }

  /// 🧹 Tüm cache'i temizle
  Future<bool> clearAll() async {
    try {
      final prefs = await _preferences;
      await prefs.clear();
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.clearAll error: $e\n$stackTrace');
      return false;
    }
  }

  /// ✓ Cache'de var mı kontrol et
  ///
  /// [checkExpiry] - TTL kontrolü yap (varsayılan: true)
  Future<bool> exists({required String key, bool checkExpiry = true}) async {
    try {
      final prefs = await _preferences;

      if (!prefs.containsKey(key)) return false;

      if (checkExpiry) {
        final expiryTime = prefs.getInt('${key}_expiry');
        if (expiryTime == null) return false;

        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (now > expiryTime) return false;
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.exists error: $e\n$stackTrace');
      return false;
    }
  }

  /// ⏱️ TTL güncelle
  Future<bool> updateExpiry({
    required String key,
    required int duration,
  }) async {
    try {
      final prefs = await _preferences;

      if (!prefs.containsKey(key)) return false;

      final newExpiryTime = DateTime.now()
              .add(Duration(seconds: duration))
              .millisecondsSinceEpoch ~/
          1000;

      await prefs.setInt('${key}_expiry', newExpiryTime);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.updateExpiry error: $e\n$stackTrace');
      return false;
    }
  }

  /// ⏰ Kalan süreyi saniye cinsinden döndür
  Future<int?> getRemainingTime({required String key}) async {
    try {
      final prefs = await _preferences;
      final expiryTime = prefs.getInt('${key}_expiry');

      if (expiryTime == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (now > expiryTime) return null;

      return expiryTime - now;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.getRemainingTime error: $e\n$stackTrace');
      return null;
    }
  }

  /// 📋 Tüm cache key'lerini listele
  ///
  /// [includeExpired] - Expired key'leri de dahil et
  Future<List<String>> getKeys({bool includeExpired = false}) async {
    try {
      final prefs = await _preferences;
      final allKeys = prefs.getKeys();

      // Sadece veri key'leri (_expiry hariç)
      final dataKeys =
          allKeys.where((key) => !key.endsWith('_expiry')).toList();

      if (includeExpired) return dataKeys;

      // Valid key'leri filtrele
      final validKeys = <String>[];
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      for (final key in dataKeys) {
        final expiryTime = prefs.getInt('${key}_expiry');
        if (expiryTime != null && now <= expiryTime) {
          validKeys.add(key);
        }
      }

      return validKeys;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.getKeys error: $e\n$stackTrace');
      return [];
    }
  }

  /// 📊 Cache istatistikleri
  ///
  /// **Dönen Bilgiler:**
  /// - totalItems: Toplam cache girişi
  /// - validItems: Geçerli girişler
  /// - expiredItems: Süresi dolmuş girişler
  /// - totalSizeBytes: Yaklaşık boyut (byte)
  /// - totalSizeKB: Yaklaşık boyut (KB)
  Future<Map<String, dynamic>> getStats() async {
    try {
      final prefs = await _preferences;
      final allKeys = prefs.getKeys();

      final dataKeys =
          allKeys.where((key) => !key.endsWith('_expiry')).toList();
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      int validCount = 0;
      int expiredCount = 0;
      int totalSize = 0;

      for (final key in dataKeys) {
        final expiryTime = prefs.getInt('${key}_expiry');
        if (expiryTime != null) {
          if (now <= expiryTime) {
            validCount++;
          } else {
            expiredCount++;
          }
        }

        final data = prefs.getString(key);
        if (data != null) totalSize += data.length;
      }

      return {
        'totalItems': dataKeys.length,
        'validItems': validCount,
        'expiredItems': expiredCount,
        'totalSizeBytes': totalSize,
        'totalSizeKB': (totalSize / 1024).toStringAsFixed(2),
      };
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.getStats error: $e\n$stackTrace');
      return {'error': e.toString()};
    }
  }

  /// 🧹 Expired cache'leri temizle
  ///
  /// **Dönüş:** Temizlenen girdi sayısı
  Future<int> clearExpired() async {
    try {
      final prefs = await _preferences;
      final allKeys = prefs.getKeys();
      final dataKeys =
          allKeys.where((key) => !key.endsWith('_expiry')).toList();

      int removedCount = 0;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      for (final key in dataKeys) {
        final expiryTime = prefs.getInt('${key}_expiry');
        if (expiryTime != null && now > expiryTime) {
          await Future.wait([prefs.remove(key), prefs.remove('${key}_expiry')]);
          removedCount++;
        }
      }

      return removedCount;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.clearExpired error: $e\n$stackTrace');
      return 0;
    }
  }

  /// 📦 Bulk set - birden fazla veriyi aynı anda kaydet
  ///
  /// **Performans:** Parallel write işlemi yapar
  Future<bool> setMultiple({
    required Map<String, dynamic> items,
    required int duration,
  }) async {
    try {
      // Parallel execution için Future.wait kullan
      await Future.wait(
        items.entries.map(
          (entry) => set(key: entry.key, data: entry.value, duration: duration),
        ),
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.setMultiple error: $e\n$stackTrace');
      return false;
    }
  }

  /// 📦 Bulk get - birden fazla veriyi aynı anda getir
  ///
  /// **Performans:** Parallel read işlemi yapar
  Future<Map<String, dynamic>> getMultiple({required List<String> keys}) async {
    try {
      // Parallel execution
      final results = await Future.wait(keys.map((key) => get(key: key)));

      final resultMap = <String, dynamic>{};
      for (int i = 0; i < keys.length; i++) {
        if (results[i] != null) {
          resultMap[keys[i]] = results[i];
        }
      }

      return resultMap;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.getMultiple error: $e\n$stackTrace');
      return {};
    }
  }

  /// 🗑️ Bulk remove - birden fazla veriyi aynı anda sil
  Future<bool> removeMultiple({required List<String> keys}) async {
    try {
      await Future.wait(keys.map((key) => remove(key: key)));
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ EasyCacheService.removeMultiple error: $e\n$stackTrace');
      return false;
    }
  }
}
