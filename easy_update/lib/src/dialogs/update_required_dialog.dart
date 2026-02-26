// 📦 UpdateRequiredDialog
//
// Uygulama güncelleme gerektiğinde gösterilen dialog.
// Zorunlu güncelleme ise "Daha sonra" butonu yoktur.
//
// **Kullanım (GetX ile):**
// ```dart
// await Get.dialog(
//   UpdateRequiredDialog(
//     forceUpdate: true,
//     storeUrl: 'https://play.google.com/store/apps/details?id=...',
//     onUpdate: () async {
//       await launchUrl(Uri.parse(storeUrl));
//     },
//   ),
//   barrierDismissible: false,
// );
// ```

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/easy_update_localizations.dart';

class UpdateRequiredDialog extends StatefulWidget {
  /// Güncelleme zorunlu mu? (true ise "Daha sonra" butonu gösterilmez)
  final bool forceUpdate;

  /// App Store / Google Play URL'si
  final String storeUrl;

  /// Dil kodu (tr, en, es, pt, de)
  final String locale;

  /// Güncelle butonuna tıklandığında çağrılan callback
  final VoidCallback? onUpdate;

  /// Daha Sonra butonuna tıklandığında çağrılan callback (opsiyonel)
  final VoidCallback? onLater;

  const UpdateRequiredDialog({
    super.key,
    required this.forceUpdate,
    required this.storeUrl,
    this.locale = 'en',
    this.onUpdate,
    this.onLater,
  });

  @override
  State<UpdateRequiredDialog> createState() => _UpdateRequiredDialogState();
}

class _UpdateRequiredDialogState extends State<UpdateRequiredDialog> {
  bool _isLoading = false;

  /// 🔗 Store URL'sini aç
  Future<void> _openStore() async {
    if (widget.storeUrl.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      if (await canLaunchUrl(Uri.parse(widget.storeUrl))) {
        await launchUrl(
          Uri.parse(widget.storeUrl),
          mode: LaunchMode.externalApplication,
        );

        // Callback varsa çağır
        widget.onUpdate?.call();
      }
    } catch (e) {
      debugPrint('❌ [EasyUpdate] Error opening store: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 👈 Daha Sonra butonu tıklanması
  void _onLater() {
    widget.onLater?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUpdateLocalizations.of(widget.locale);

    return PopScope(
      canPop: !widget.forceUpdate,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎉 Header - Logo/Icon
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.system_update,
                  size: 40,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16),

              // 📝 Başlık
              Text(
                widget.forceUpdate ? l10n.updateRequired : l10n.updateAvailable,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // 📄 İçerik
              Text(
                widget.forceUpdate
                    ? l10n.updateMessage
                    : l10n.optionalUpdateMessage,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 🔘 Butonlar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _openStore,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.download),
                  label: Text(
                    l10n.updateButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Daha sonra butonu - Zorunlu değilse göster
              if (!widget.forceUpdate)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isLoading ? null : _onLater,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      l10n.laterButton,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
