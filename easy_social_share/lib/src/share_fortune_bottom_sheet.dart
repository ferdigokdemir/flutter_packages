import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'easy_social_share_singleton.dart';

/// Fal paylaşımı için bottom sheet dialog
/// 1. Kopyala - Verilen metni clipboard'a kopyalar
/// 2. Sosyal Medya'da Paylaş - Content widget'ı Instagram'a paylaşır
class SharedFortuneBottomSheet extends StatefulWidget {
  /// Kopyalanacak ve paylaşılacak metin
  final String text;

  /// Paylaş kartı içeriği (Widget)
  final Widget content;

  /// Paylaşım başarılı callback'i
  final VoidCallback? onShareSuccess;

  /// Kopyalama başarılı callback'i
  final VoidCallback? onCopySuccess;

  const SharedFortuneBottomSheet({
    super.key,
    required this.text,
    required this.content,
    this.onShareSuccess,
    this.onCopySuccess,
  });

  /// Bottom sheet göster
  static Future<String?> show({
    required BuildContext context,
    required String text,
    required Widget content,
    VoidCallback? onShareSuccess,
    VoidCallback? onCopySuccess,
  }) async {
    return await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => SharedFortuneBottomSheet(
        text: text,
        content: content,
        onShareSuccess: onShareSuccess,
        onCopySuccess: onCopySuccess,
      ),
    );
  }

  @override
  State<SharedFortuneBottomSheet> createState() =>
      _SharedFortuneBottomSheetState();
}

class _SharedFortuneBottomSheetState extends State<SharedFortuneBottomSheet> {
  bool _isCopying = false;
  bool _isSharing = false;

  /// Metni clipboard'a kopyala
  Future<void> _copyToClipboard() async {
    setState(() => _isCopying = true);

    try {
      await Clipboard.setData(
        ClipboardData(text: widget.text),
      );

      HapticFeedback.mediumImpact();

      widget.onCopySuccess?.call();

      // Başarı mesajı göster
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Açıklama clipboard\'a kopyalandı'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Dialog'u kapat
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.of(context).pop();
      });
    } catch (e) {
      HapticFeedback.heavyImpact();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Kopyalama başarısız oldu'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isCopying = false);
    }
  }

  /// Sosyal medya paylaşım önizleme diyaloğu göster
  Future<void> _showPreviewDialog() async {
    setState(() => _isSharing = true);

    try {
      HapticFeedback.mediumImpact();

      if (!mounted) {
        setState(() => _isSharing = false);
        return;
      }

      // Önizleme diyaloğunu göster
      await showDialog<void>(
        context: context,
        builder: (context) => _PreviewShareDialog(
          content: widget.content,
          onShareSuccess: widget.onShareSuccess,
        ),
      );

      // Başarılı paylaşım sonrası bottom sheet'i kapat
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoActionSheet(
        title: const Text('🔮 Paylaş'),
        message: const Text(
          "Açıklamayı kopyalayabilir veya sosyal medyada kolayca paylaşabilirsin! ✨",
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          _buildCopyOption(),
          _buildShareOption(),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          isDefaultAction: true,
          child: const Text('İptal'),
        ),
      ),
    );
  }

  Widget _buildCopyOption() {
    final isDisabled = _isCopying;

    return CupertinoActionSheetAction(
      onPressed: isDisabled
          ? () {}
          : () {
              _copyToClipboard();
            },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isCopying
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.content_copy, size: 24, color: Colors.amber),
            Text(
              _isCopying ? 'Kopyalanıyor...' : 'Açıklamayı Kopyala',
              style: const TextStyle(color: Colors.amber, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption() {
    final isDisabled = _isSharing;

    return CupertinoActionSheetAction(
      onPressed: isDisabled
          ? () {}
          : () {
              _showPreviewDialog();
            },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isSharing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share_outlined,
                    size: 24, color: Colors.blue),
            Text(
              _isSharing ? 'Yükleniyor...' : '📱 Sosyal Medya\'da Paylaş',
              style: const TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paylaşım önizlemesi diyaloğu
class _PreviewShareDialog extends StatefulWidget {
  final Widget content;
  final VoidCallback? onShareSuccess;

  const _PreviewShareDialog({
    required this.content,
    this.onShareSuccess,
  });

  @override
  State<_PreviewShareDialog> createState() => _PreviewShareDialogState();
}

class _PreviewShareDialogState extends State<_PreviewShareDialog> {
  bool _isSharing = false;

  /// Sosyal medyaya paylaş
  Future<void> _shareToSocialMedia() async {
    setState(() => _isSharing = true);

    try {
      HapticFeedback.mediumImpact();

      final result = await EasySocialShare.instance.shareWidget(
        widget: _buildShareContent(),
        content: null,
      );

      if (result.success) {
        widget.onShareSuccess?.call();

        if (!mounted) return;

        // Başarı gösterimi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sosyal medyada paylaşıldı'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } catch (e) {
      HapticFeedback.heavyImpact();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Paylaşım başarısız: $e'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  /// 9:16 aspect ratio ile paylaşım içeriği oluştur
  Widget _buildShareContent() {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1080,
          maxHeight: 1920,
        ),
        child: widget.content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              child: Center(
                child: _buildShareContent(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
                width: double.maxFinite,
                child: FilledButton.icon(
                  onPressed: _isSharing ? null : _shareToSocialMedia,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.share),
                  label: Text(
                    _isSharing ? 'Paylaşılıyor...' : 'Paylaş',
                    style: const TextStyle(fontSize: 16),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
