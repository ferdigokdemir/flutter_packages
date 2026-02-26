import 'dart:io';
import 'package:flutter/material.dart';
import '../services/version_check_service.dart';
import '../models/version_check_status.dart';

typedef EasyUpdateBuilder =
    Widget Function(BuildContext context, VersionCheckStatus status);

/// EasyUpdateGate
///
/// - Dışarıdan version ve force alır.
/// - Versiyon kontrolünü yapar, gerekiyorsa update dialog'unu kendi açar.
/// - Zorunlu update mantığı: force true ise ve currentVersion < version ise kullanıcıyı engeller.
class EasyUpdateGate extends StatefulWidget {
  final String version;
  final bool force;
  final Widget child;

  /// Play Store URL
  final String? playStoreUrl;

  /// App Store URL
  final String? appStoreUrl;

  /// Güncelleme gerekli olduğunda dialog yerine döndürülecek widget.
  /// Örn: Tam ekran bir Scaffold.
  /// VersionCheckStatus ile force/storeUrl vb. bilgilere erişebilirsiniz.
  final EasyUpdateBuilder? updateBuilder;

  const EasyUpdateGate({
    super.key,
    this.version = '0.0.0',
    this.force = false,
    this.child = const SizedBox.shrink(),
    this.playStoreUrl,
    this.appStoreUrl,
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
    try {
      // Service: version ve force parametreleri ile oluştur
      final service = VersionCheckService(
        version: widget.version,
        force: widget.force,
        storeUrl: _getStoreUrl(),
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

  /// Platforma göre store URL döndür
  String _getStoreUrl() {
    if (Platform.isAndroid) {
      return widget.playStoreUrl ?? '';
    }
    if (Platform.isIOS) {
      return widget.appStoreUrl ?? '';
    }
    return '';
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
