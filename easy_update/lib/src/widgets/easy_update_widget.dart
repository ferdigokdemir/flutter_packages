import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/easy_update_localizations.dart';
import '../models/version_check_status.dart';
import '../services/version_check_service.dart';

/// 🚀 EasyUpdateWidget
///
/// MaterialApp'in `builder` parametresine eklenebilen bir widget.
/// Uygulama açıldığında otomatik olarak versiyon kontrolü yapar ve
/// güncelleme gerekliyse dialog gösterir.
///
/// **Kullanım:**
/// ```dart
/// final _navigatorKey = GlobalKey<NavigatorState>();
///
/// MaterialApp(
///   navigatorKey: _navigatorKey,
///   builder: (context, child) {
///     return EasyUpdateWidget(
///       navigatorKey: _navigatorKey,
///       android: EasyUpdatePlatformConfig(
///         version: '2.0.0',
///         storeUrl: 'https://play.google.com/store/apps/details?id=...',
///         force: true,
///         locale: 'tr',
///       ),
///       ios: EasyUpdatePlatformConfig(
///         version: '2.0.0',
///         storeUrl: 'https://apps.apple.com/app/id123456789',
///         force: true,
///         locale: 'tr',
///       ),
///       child: child!,
///     );
///   },
/// )
/// ```
class EasyUpdateWidget extends StatefulWidget {
  /// MaterialApp ile paylaşılan navigator key.
  /// Dialog'u navigasyon stack'inin üzerinde göstermek için gereklidir.
  final GlobalKey<NavigatorState> navigatorKey;

  /// Android için platform konfigürasyonu
  final EasyUpdatePlatformConfig? android;

  /// iOS için platform konfigürasyonu
  final EasyUpdatePlatformConfig? ios;

  /// Alt widget (MaterialApp'ten gelen child)
  final Widget child;

  /// Versiyon kontrolü sırasında hata oluşursa çağrılır (opsiyonel)
  final void Function(Object error, StackTrace stackTrace)? onException;

  /// Versiyon kontrolünden önce bekleme süresi (milisaniye).
  /// Varsayılan: 0 (bekleme yok)
  final int delayMilliseconds;

  const EasyUpdateWidget({
    super.key,
    required this.navigatorKey,
    required this.child,
    this.android,
    this.ios,
    this.onException,
    this.delayMilliseconds = 0,
  }) : assert(
         android != null || ios != null,
         'At least one platform config (android or ios) must be provided.',
       );

  @override
  State<EasyUpdateWidget> createState() => _EasyUpdateWidgetState();
}

class _EasyUpdateWidgetState extends State<EasyUpdateWidget> {
  @override
  void initState() {
    super.initState();
    _scheduleUpdateCheck();
  }

  void _scheduleUpdateCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.delayMilliseconds > 0) {
        await Future<void>.delayed(
          Duration(milliseconds: widget.delayMilliseconds),
        );
      }
      await _checkAndShowUpdate();
    });
  }

  EasyUpdatePlatformConfig? get _platformConfig {
    if (Platform.isAndroid) return widget.android;
    if (Platform.isIOS) return widget.ios;
    return null;
  }

  Future<void> _checkAndShowUpdate() async {
    final config = _platformConfig;
    if (config == null) {
      debugPrint('⚠️ [EasyUpdateWidget] No config for current platform');
      return;
    }

    try {
      final service = VersionCheckService(
        version: config.version,
        force: config.force,
        storeUrl: config.storeUrl,
      );

      // Versiyon kontrolü yap
      final status = await service.checkForUpdates();

      if (!status.updateRequired) {
        debugPrint('✅ [EasyUpdateWidget] App is up to date');
        return;
      }

      // Kullanıcının bu sürümü skip edip etmediğini kontrol et
      final prefs = await SharedPreferences.getInstance();
      final skippedVersion = prefs.getString('easy_update_skipped_version');
      if (!status.force && skippedVersion == status.version) {
        debugPrint(
          '⏭️ [EasyUpdateWidget] Version ${status.version} skipped by user',
        );
        return;
      }

      // Navigator hazır olana kadar bekle
      final navigator = widget.navigatorKey.currentState;
      if (navigator == null) {
        debugPrint('⚠️ [EasyUpdateWidget] Navigator not ready');
        return;
      }

      await navigator.push(
        _UpdateDialogRoute(status: status, locale: config.locale),
      );
    } catch (e, st) {
      debugPrint('❌ [EasyUpdateWidget] Error: $e');
      widget.onException?.call(e, st);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Güncelleme dialog'u için özel bir Route.
/// Zorunlu güncellemelerde kullanıcının geri gitmesini engeller.
class _UpdateDialogRoute extends ModalRoute<void> {
  final VersionCheckStatus status;
  final String locale;

  _UpdateDialogRoute({required this.status, required this.locale});

  @override
  bool get barrierDismissible => !status.force;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => 'Update Dialog';

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _EasyUpdateDialog(status: status, locale: locale);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class _EasyUpdateDialog extends StatefulWidget {
  final VersionCheckStatus status;
  final String locale;

  const _EasyUpdateDialog({required this.status, required this.locale});

  @override
  State<_EasyUpdateDialog> createState() => _EasyUpdateDialogState();
}

class _EasyUpdateDialogState extends State<_EasyUpdateDialog> {
  bool _isLoading = false;

  Future<void> _openStore() async {
    final url = Uri.parse(widget.status.storeUrl);
    setState(() => _isLoading = true);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('❌ [EasyUpdateWidget] Cannot launch store URL: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onLater() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('easy_update_skipped_version', widget.status.version);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUpdateLocalizations.of(widget.locale);

    return PopScope(
      canPop: !widget.status.force,
      child: Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            widget.status.force ? l10n.updateRequired : l10n.updateAvailable,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 48, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  widget.status.force
                      ? l10n.updateMessage
                      : l10n.optionalUpdateMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _openStore,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.updateButton),
                ),
                if (!widget.status.force)
                  TextButton(
                    onPressed: _onLater,
                    child: Text(
                      l10n.laterButton,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
