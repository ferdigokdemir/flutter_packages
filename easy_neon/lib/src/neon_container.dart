import 'dart:ui';
import 'package:flutter/material.dart';

/// 🌟 Neon efektli container widget'ı
///
/// Glassmorphism (blur) desteği ile AppBar title, chip, badge,
/// card header, toast gibi birçok yerde kullanılabilir.
///
/// Örnek kullanım:
/// ```dart
/// // AppBar title
/// NeonContainer(
///   neonColor: Color(0xFFFF00AA),
///   blur: true,
///   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
///   child: Text('Seviye 5'),
/// )
///
/// // Badge/Chip
/// NeonContainer(
///   neonColor: Color(0xFF00FF88),
///   borderRadius: 16,
///   child: Row(children: [Icon(...), Text('Completed')]),
/// )
/// ```
class NeonContainer extends StatefulWidget {
  const NeonContainer({
    super.key,
    required this.child,
    this.neonColor = const Color(0xFFFF00AA),
    this.blur = false,
    this.blurIntensity = 10.0,
    this.borderRadius = 20.0,
    this.padding,
    this.borderWidth = 2.0,
    this.glowIntensity = 0.6,
    this.width,
    this.height,
    this.onTap,
    // Görsel efektler
    this.pulse = false,
    this.shimmer = false,
    this.doubleBorder = false,
    this.neonGradient,
    this.innerGlow = false,
    this.backgroundColor,
    // Animasyon
    this.animateIn = false,
    // Fonksiyonel
    this.badge,
    this.badgeColor,
    this.badgePosition = BadgePosition.topRight,
    this.tooltip,
    this.semanticLabel,
  });

  /// Container içeriği
  final Widget child;

  /// Neon efekti için kullanılacak ana renk
  final Color neonColor;

  /// Glassmorphism blur efekti
  final bool blur;

  /// Blur yoğunluğu (sigmaX ve sigmaY değeri)
  final double blurIntensity;

  /// Köşe yuvarlaklığı
  final double borderRadius;

  /// İçerik padding'i
  final EdgeInsets? padding;

  /// Border kalınlığı
  final double borderWidth;

  /// Glow efekti yoğunluğu (0.0 - 1.0 arası)
  final double glowIntensity;

  /// Container genişliği
  final double? width;

  /// Container yüksekliği
  final double? height;

  /// Tıklama callback'i
  final VoidCallback? onTap;

  // ─── Görsel Efektler ───

  /// Nabız gibi atan neon efekti
  final bool pulse;

  /// Parlak kayma efekti
  final bool shimmer;

  /// İç + dış çift border
  final bool doubleBorder;

  /// Gradientli neon rengi [başlangıç, bitiş]
  final List<Color>? neonGradient;

  /// İçe doğru glow efekti
  final bool innerGlow;

  /// Özel arka plan rengi (null ise neonColor'ın %20 alpha'sı)
  final Color? backgroundColor;

  // ─── Animasyon ───

  /// İlk görünümde animasyon
  final bool animateIn;

  // ─── Fonksiyonel ───

  /// Badge metni
  final String? badge;

  /// Badge arka plan rengi
  final Color? badgeColor;

  /// Badge pozisyonu
  final BadgePosition badgePosition;

  /// Tooltip metni
  final String? tooltip;

  /// Accessibility için semantik etiket
  final String? semanticLabel;

  @override
  State<NeonContainer> createState() => _NeonContainerState();
}

/// Badge pozisyon seçenekleri
enum BadgePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _NeonContainerState extends State<NeonContainer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _entryController;
  late AnimationController _shimmerController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _entryAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Pulse animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.pulse) {
      _pulseController.repeat(reverse: true);
    }

    // Entry animasyonu
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );
    if (widget.animateIn) {
      _entryController.forward();
    } else {
      _entryController.value = 1.0;
    }

    // Shimmer animasyonu
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    if (widget.shimmer) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(NeonContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pulse kontrolü
    if (widget.pulse && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.pulse && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    // Shimmer kontrolü
    if (widget.shimmer && !_shimmerController.isAnimating) {
      _shimmerController.repeat();
    } else if (!widget.shimmer && _shimmerController.isAnimating) {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget containerContent = _buildContainerContent();

    // Entry animasyonu
    if (widget.animateIn) {
      containerContent = ScaleTransition(
        scale: _entryAnimation,
        child: containerContent,
      );
    }

    // Tooltip
    if (widget.tooltip != null) {
      containerContent = Tooltip(
        message: widget.tooltip!,
        child: containerContent,
      );
    }

    // Semantics
    if (widget.semanticLabel != null) {
      containerContent = Semantics(
        label: widget.semanticLabel,
        container: true,
        child: containerContent,
      );
    }

    // Tıklanabilir
    if (widget.onTap != null) {
      containerContent = GestureDetector(
        onTap: widget.onTap,
        child: containerContent,
      );
    }

    return containerContent;
  }

  Widget _buildContainerContent() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Ana container
            _buildMainContainer(),

            // Badge
            if (widget.badge != null) _buildBadge(),
          ],
        );
      },
    );
  }

  Widget _buildMainContainer() {
    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: _buildDecoration(),
      child: Stack(
        children: [
          // Shimmer efekti
          if (widget.shimmer)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: _buildShimmerOverlay(),
              ),
            ),

          // İçerik
          widget.child,
        ],
      ),
    );

    // Blur efekti
    if (widget.blur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurIntensity,
            sigmaY: widget.blurIntensity,
          ),
          child: container,
        ),
      );
    }

    return container;
  }

  Widget _buildShimmerOverlay() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Container(color: Colors.white),
        );
      },
    );
  }

  Widget _buildBadge() {
    final badgeColor = widget.badgeColor ?? Colors.red;

    // Pozisyon
    double? top, right, bottom, left;
    switch (widget.badgePosition) {
      case BadgePosition.topLeft:
        top = -6;
        left = -6;
      case BadgePosition.topRight:
        top = -6;
        right = -6;
      case BadgePosition.bottomLeft:
        bottom = -6;
        left = -6;
      case BadgePosition.bottomRight:
        bottom = -6;
        right = -6;
    }

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        child: Center(
          child: Text(
            widget.badge!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    // Neon rengi
    final effectiveNeonColor = widget.neonGradient != null
        ? widget.neonGradient!.first
        : widget.neonColor;

    // Glow yoğunluğu
    double currentGlowIntensity = widget.glowIntensity;
    if (widget.pulse) {
      currentGlowIntensity *= _pulseAnimation.value;
    }

    // Arka plan rengi
    final backgroundColor =
        widget.backgroundColor ?? effectiveNeonColor.withValues(alpha: 0.2);

    // Border rengi
    final borderColor = effectiveNeonColor.withValues(alpha: 0.8);

    // Glow efekti
    final List<BoxShadow> shadows = [
      BoxShadow(
        color: effectiveNeonColor.withValues(alpha: currentGlowIntensity),
        blurRadius: 12,
        spreadRadius: 2,
      ),
    ];

    // Inner glow
    if (widget.innerGlow) {
      shadows.add(
        BoxShadow(
          color: effectiveNeonColor.withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: -4,
        ),
      );
    }

    // Double border efekti
    if (widget.doubleBorder) {
      shadows.add(
        BoxShadow(
          color: effectiveNeonColor.withValues(alpha: 0.4),
          spreadRadius: widget.borderWidth + 3,
        ),
      );
    }

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(
        color: borderColor,
        width: widget.borderWidth,
      ),
      boxShadow: shadows,
    );
  }
}
