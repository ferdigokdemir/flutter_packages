import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/easy_update_localizations.dart';
import '../models/version_check_status.dart';
import '../services/easy_update.dart';

/// Güncelleme için üstte gösterilen ince, kapatılamayan banner şerit.
///
/// Mesaj [VersionCheckStatus.force]'a göre seçilir:
/// - `force == true`  → [EasyUpdateLocalizations.bannerForceMessage]
/// - `force == false` → [EasyUpdateLocalizations.bannerMessage]
///
/// Şeride veya butona dokununca [VersionCheckStatus.storeUrl] açılır.
/// Renkler parametre ile özelleştirilebilir.
class UpdateBanner extends StatelessWidget {
  final VersionCheckStatus status;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color actionBackgroundColor;
  final Color actionForegroundColor;

  const UpdateBanner({
    super.key,
    required this.status,
    this.backgroundColor = Colors.pinkAccent,
    this.foregroundColor = Colors.black87,
    this.actionBackgroundColor = Colors.black87,
    this.actionForegroundColor = Colors.white,
  });

  Future<void> _openStore() async {
    final url = Uri.parse(status.storeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUpdateLocalizations.of(EasyUpdate.instance.locale);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: _openStore,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.system_update, size: 24, color: foregroundColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status.force ? l10n.bannerForceMessage : l10n.bannerMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: _openStore,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: actionBackgroundColor,
                  foregroundColor: actionForegroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  l10n.updateButton.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
