import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  /// Güncelleme gerekli olduğunda dialog yerine döndürülecek widget.
  /// Örn: Tam ekran bir Scaffold.
  /// VersionCheckStatus ile forceUpdate/storeUrl vb. bilgilere erişebilirsiniz.
  final EasyUpdateBuilder updateBuilder;

  const EasyUpdateGate({
    super.key,
    required this.minimumVersion,
    required this.forceUpdate,
    required this.child,
    required this.updateBuilder,
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
        storeUrl: await _buildStoreUrl(),
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

  /// Platforma göre store URL üret
  /// - Android: Play Store paket adına göre
  /// - iOS: App adı ile arama sonucu (ID bilinmiyorsa)
  Future<String> _buildStoreUrl() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (Platform.isAndroid) {
        return 'https://play.google.com/store/apps/details?id=${info.packageName}';
      }
      if (Platform.isIOS) {
        final appName = Uri.encodeComponent(info.appName);
        // AppStore ID bilinmiyorsa arama sayfasına yönlendir
        return 'https://apps.apple.com/tr/search?term=$appName';
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Güncelleme gerekli ise özel builder'ı döndür
    if (_updateRequired && _status != null) {
      return widget.updateBuilder(context, _status!);
    }

    // Aksi halde normal child'ı döndür
    return widget.child;
  }
}
