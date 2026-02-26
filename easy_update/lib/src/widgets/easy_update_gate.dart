import 'dart:io';
import 'package:flutter/material.dart';
import '../services/version_check_service.dart';
import '../models/version_check_status.dart';

typedef EasyUpdateBuilder =
    Widget Function(BuildContext context, VersionCheckStatus status);

/// EasyUpdateGate
///
/// - Dışarıdan android ve ios EasyUpdatePlatformConfig alır.
/// - Versiyon kontrolünü yapar, gerekiyorsa update dialog'unu kendi açar.
/// - Zorunlu update mantığı: force true ise ve currentVersion < version ise kullanıcıyı engeller.
class EasyUpdateGate extends StatefulWidget {
  /// Android için EasyUpdatePlatformConfig
  final EasyUpdatePlatformConfig? android;

  /// iOS için EasyUpdatePlatformConfig
  final EasyUpdatePlatformConfig? ios;

  final Widget child;

  /// Güncelleme gerekli olduğunda dialog yerine döndürülecek widget.
  /// Örn: Tam ekran bir Scaffold.
  /// VersionCheckStatus ile force/storeUrl vb. bilgilere erişebilirsiniz.
  final EasyUpdateBuilder? updateBuilder;

  const EasyUpdateGate({
    super.key,
    this.android,
    this.ios,
    this.child = const SizedBox.shrink(),
    this.updateBuilder,
  });

  @override
  State<EasyUpdateGate> createState() => _EasyUpdateGateState();
}

class _EasyUpdateGateState extends State<EasyUpdateGate> {
  bool _updateRequired = false;
  VersionCheckStatus? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    // Platforma göre config seç
    final config = _getPlatformConfig();
    if (config == null) {
      debugPrint('⚠️ [EasyUpdateGate] No config for current platform');
      return;
    }

    try {
      // Service: config parametreleri ile oluştur
      final service = VersionCheckService(
        version: config.version,
        force: config.force,
        storeUrl: config.storeUrl,
      );

      final status = await service.checkForUpdates();

      if (!mounted) return;

      // State'i güncelle
      setState(() {
        _status = status;
        _updateRequired = status.updateRequired;
      });
    } catch (e) {
      // Sessizce geç, uygulamayı bloklama
      debugPrint('❌ [EasyUpdateGate] $e');
    } finally {}
  }

  /// Platforma göre config döndür
  EasyUpdatePlatformConfig? _getPlatformConfig() {
    if (Platform.isAndroid) {
      return widget.android;
    }
    if (Platform.isIOS) {
      return widget.ios;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Güncelleme gerekli ise özel builder'ı döndür (eğer builder varsa)
    if (_updateRequired && _status != null && widget.updateBuilder != null) {
      return widget.updateBuilder!(context, _status!);
    }

    // Aksi halde normal child'ı döndür
    return widget.child;
  }
}
