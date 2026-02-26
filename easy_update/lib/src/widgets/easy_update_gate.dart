import 'dart:io';
import 'package:flutter/material.dart';
import '../services/version_check_service.dart';
import '../models/version_check_status.dart';

typedef EasyUpdateBuilder =
    Widget Function(BuildContext context, VersionCheckStatus status);

/// EasyUpdateGate
///
/// - Dışarıdan minimumVersion ve forceUpdate alır.
/// - Versiyon kontrolünü yapar, gerekiyorsa update dialog'unu kendi açar.
/// - Zorunlu update mantığı: forceUpdate true ise ve currentVersion < minimumVersion ise kullanıcıyı engeller.
class EasyUpdateGate extends StatefulWidget {
  final String minimumVersion;
  final bool forceUpdate;
  final Widget child;

  /// Android Play Store URL
  final String? androidStoreUrl;

  /// iOS App Store URL
  final String? iosStoreUrl;

  /// Güncelleme gerekli olduğunda dialog yerine döndürülecek widget.
  /// Örn: Tam ekran bir Scaffold.
  /// VersionCheckStatus ile forceUpdate/storeUrl vb. bilgilere erişebilirsiniz.
  final EasyUpdateBuilder? updateBuilder;

  const EasyUpdateGate({
    super.key,
    this.minimumVersion = '0.0.0',
    this.forceUpdate = false,
    this.child = const SizedBox.shrink(),
    this.androidStoreUrl,
    this.iosStoreUrl,
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
      // Service: minimumVersion ve forceUpdate parametreleri ile oluştur
      final service = VersionCheckService(
        minimumVersion: widget.minimumVersion,
        forceUpdate: widget.forceUpdate,
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
      return widget.androidStoreUrl ?? '';
    }
    if (Platform.isIOS) {
      return widget.iosStoreUrl ?? '';
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
