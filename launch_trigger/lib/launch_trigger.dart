import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama acilis/erteleme sayaclarina gore tetikleme kararini verir.
class LaunchTrigger {
  /// Tetikleme kontrolu.
  ///
  /// - [launch]: ilk gosterim icin gerekli toplam acilis sayisi
  /// - [remind]: erteleme sonrasi yeniden gosterim icin temel esik
  /// - [remindStep]: her ertelemeyle artacak ek adim (or. 2 => 5,7,9 ...)
  /// - [ignoreExpireDays]: ignore'in X gun sonra otomatik sifirlanmasi icin sure
  static Future<bool> shouldTrigger({
    required String prefix,
    int launch = 3,
    int remind = 5,
    int remindStep = 0,
    int? ignoreExpireDays,
    bool dryRun = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    int launchCount = prefs.getInt('${prefix}_launch_count') ?? 0;
    int remindCount = prefs.getInt('${prefix}_remind_count') ?? 0;
    bool dismissed = prefs.getBool('${prefix}_dismissed') ?? false;
    bool ignored = prefs.getBool('${prefix}_ignored') ?? false;

    // Ignore suresi dolduysa otomatik kaldir
    if (ignored && ignoreExpireDays != null) {
      final ignoredAtMs = prefs.getInt('${prefix}_ignored_at_ms') ?? 0;
      if (ignoredAtMs > 0) {
        final nowMs = DateTime.now().millisecondsSinceEpoch;
        final expireMs = ignoreExpireDays * 24 * 60 * 60 * 1000;
        if (nowMs - ignoredAtMs >= expireMs) {
          if (!dryRun) {
            await prefs.setBool('${prefix}_ignored', false);
            await prefs.remove('${prefix}_ignored_at_ms');
          }
          ignored = false;
        }
      }
      if (ignored) return false;
    } else if (ignored) {
      return false;
    }

    // Launch sayacini artir: dryRun'da sadece hesaplamada artmis say
    if (dryRun) {
      launchCount = launchCount + 1;
    } else {
      launchCount++;
      await prefs.setInt('${prefix}_launch_count', launchCount);
    }

    final dismissCount = prefs.getInt('${prefix}_dismiss_count') ?? 0;
    final requiredRemind =
        remind + (dismissCount * (remindStep < 0 ? 0 : remindStep));

    final reachedLaunchThreshold = !dismissed && launchCount >= launch;
    final reachedRemindThreshold = dismissed && remindCount >= requiredRemind;

    if (reachedLaunchThreshold || reachedRemindThreshold) {
      if (!dryRun) {
        await prefs.setInt('${prefix}_remind_count', 0);
      }
      return true;
    }

    if (dismissed) {
      if (!dryRun) {
        remindCount++;
        await prefs.setInt('${prefix}_remind_count', remindCount);
      }
    }

    return false;
  }

  /// Kullanici "Daha sonra" dediginde cagirin.
  static Future<void> markDismissed({required String prefix}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('${prefix}_dismiss_count') ?? 0;
    await prefs.setBool('${prefix}_dismissed', true);
    await prefs.setInt('${prefix}_dismiss_count', current + 1);
  }

  /// Kullanici "Gorme/Ignore" dediginde cagirin. [expireDays] verilirse zaman asimina baglanir.
  static Future<void> markIgnored({
    required String prefix,
    int? expireDays,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${prefix}_ignored', true);
    if (expireDays != null) {
      await prefs.setInt(
        '${prefix}_ignored_at_ms',
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove('${prefix}_ignored_at_ms');
    }
  }

  /// Ilgili tum anahtarları sifirlar.
  static Future<void> reset({required String prefix}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${prefix}_launch_count');
    await prefs.remove('${prefix}_remind_count');
    await prefs.remove('${prefix}_dismissed');
    await prefs.remove('${prefix}_dismiss_count');
    await prefs.remove('${prefix}_ignored');
    await prefs.remove('${prefix}_ignored_at_ms');
  }
}
