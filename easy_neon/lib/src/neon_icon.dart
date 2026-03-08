import 'package:flutter/material.dart';

/// 🌟 Neon efektli ikon widget'ı
///
/// Tab bar, navigation ve seçilebilir ikonlar için tasarlandı.
///
/// Örnek kullanım:
/// ```dart
/// NeonIcon(
///   icon: Icons.home,
///   neonColor: Color(0xFFFF00AA),
///   isSelected: true,
///   size: 24,
///   pulse: true,
/// )
/// ```
class NeonIcon extends StatefulWidget {
  const NeonIcon({
    super.key,
    required this.icon,
    this.neonColor = const Color(0xFFFF00AA),
    this.isSelected = false,
    this.size = 24.0,
    this.iconColor,
    this.containerSize,
    this.borderWidth = 2.0,
    this.glowIntensity = 0.6,
    this.showContainer = true,
    this.onTap,
    // Görsel efektler
    this.pulse = false,
    this.shimmer = false,
    this.doubleBorder = false,
    this.neonGradient,
    this.innerGlow = false,
    // Animasyon
    this.animateIn = false,
    this.animateSelection = true,
    // Fonksiyonel
    this.badge,
    this.badgeColor,
    this.tooltip,
    this.semanticLabel,
  });

  /// Gösterilecek ikon
  final IconData icon;

  /// Neon efekti için kullanılacak ana renk
  final Color neonColor;

  /// Seçili durumu (true ise neon efekti aktif)
  final bool isSelected;

  /// İkon boyutu
  final double size;

  /// İkon rengi (null ise Colors.white)
  final Color? iconColor;

  /// Container boyutu (null ise size * 2)
  final double? containerSize;

  /// Border kalınlığı
  final double borderWidth;

  /// Glow efekti yoğunluğu (0.0 - 1.0 arası)
  final double glowIntensity;

  /// Container gösterilsin mi? (false ise sadece ikon + glow)
  final bool showContainer;

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

  // ─── Animasyon ───

  /// İlk görünümde animasyon
  final bool animateIn;

  /// Seçim değişikliğinde animasyon
  final bool animateSelection;

  // ─── Fonksiyonel ───

  /// Sağ üst köşe badge metni
  final String? badge;

  /// Badge arka plan rengi
  final Color? badgeColor;

  /// Tooltip metni
  final String? tooltip;

  /// Accessibility için semantik etiket
  final String? semanticLabel;

  @override
  State<NeonIcon> createState() => _NeonIconState();
}

class _NeonIconState extends State<NeonIcon> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _selectionController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _entryAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _selectionAnimation;

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
    if (widget.pulse && widget.isSelected) {
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
    if (widget.shimmer && widget.isSelected) {
      _shimmerController.repeat();
    }

    // Selection animasyonu
    _selectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _selectionAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _selectionController, curve: Curves.easeOut),
    );
    if (widget.isSelected) {
      _selectionController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeonIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Selection değişikliği
    if (widget.isSelected != oldWidget.isSelected && widget.animateSelection) {
      if (widget.isSelected) {
        _selectionController.forward();
      } else {
        _selectionController.reverse();
      }
    }

    // Pulse kontrolü
    if (widget.pulse && widget.isSelected && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if ((!widget.pulse || !widget.isSelected) &&
        _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    // Shimmer kontrolü
    if (widget.shimmer &&
        widget.isSelected &&
        !_shimmerController.isAnimating) {
      _shimmerController.repeat();
    } else if ((!widget.shimmer || !widget.isSelected) &&
        _shimmerController.isAnimating) {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget iconContent = _buildIconContent();

    // Entry animasyonu
    if (widget.animateIn) {
      iconContent = ScaleTransition(
        scale: _entryAnimation,
        child: iconContent,
      );
    }

    // Selection animasyonu
    if (widget.animateSelection) {
      iconContent = AnimatedBuilder(
        animation: _selectionAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _selectionAnimation.value : 1.0,
            child: child,
          );
        },
        child: iconContent,
      );
    }

    // Tooltip
    if (widget.tooltip != null) {
      iconContent = Tooltip(
        message: widget.tooltip!,
        child: iconContent,
      );
    }

    // Semantics
    if (widget.semanticLabel != null) {
      iconContent = Semantics(
        label: widget.semanticLabel,
        selected: widget.isSelected,
        child: iconContent,
      );
    }

    // Tıklanabilir
    if (widget.onTap != null) {
      iconContent = GestureDetector(
        onTap: widget.onTap,
        child: iconContent,
      );
    }

    return iconContent;
  }

  Widget _buildIconContent() {
    final containerSize = widget.containerSize ?? widget.size * 2;
    final effectiveIconColor = widget.iconColor ?? Colors.white;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Ana container
            if (widget.showContainer)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: containerSize,
                height: containerSize,
                decoration: _buildDecoration(containerSize),
                child: Stack(
                  children: [
                    // Shimmer efekti
                    if (widget.shimmer && widget.isSelected)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(containerSize / 2),
                          child: _buildShimmerOverlay(),
                        ),
                      ),

                    // İkon
                    Center(
                      child: Icon(
                        widget.icon,
                        size: widget.size,
                        color: effectiveIconColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Container olmadan sadece ikon + glow
              _buildIconOnly(effectiveIconColor),

            // Badge
            if (widget.badge != null) _buildBadge(),
          ],
        );
      },
    );
  }

  Widget _buildIconOnly(Color iconColor) {
    final effectiveNeonColor = widget.neonGradient != null && widget.isSelected
        ? widget.neonGradient!.first
        : widget.neonColor;

    return Container(
      padding: EdgeInsets.all(widget.size * 0.25),
      child: Icon(
        widget.icon,
        size: widget.size,
        color: iconColor,
        shadows: widget.isSelected
            ? [
                Shadow(
                  color: effectiveNeonColor.withValues(
                      alpha: widget.glowIntensity),
                  blurRadius: 12,
                ),
                Shadow(
                  color: effectiveNeonColor.withValues(
                      alpha: widget.glowIntensity * 0.5),
                  blurRadius: 24,
                ),
              ]
            : null,
      ),
    );
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

    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
        child: Center(
          child: Text(
            widget.badge!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(double containerSize) {
    final isSelected = widget.isSelected;

    // Neon rengi
    final effectiveNeonColor = widget.neonGradient != null && isSelected
        ? widget.neonGradient!.first
        : widget.neonColor;

    // Glow yoğunluğu
    double currentGlowIntensity = widget.glowIntensity;
    if (widget.pulse && isSelected) {
      currentGlowIntensity *= _pulseAnimation.value;
    }

    // Arka plan rengi
    final backgroundColor = isSelected
        ? effectiveNeonColor.withValues(alpha: 0.2)
        : Colors.transparent;

    // Border rengi
    final borderColor = isSelected
        ? effectiveNeonColor.withValues(alpha: 0.8)
        : Colors.transparent;

    // Glow efekti
    List<BoxShadow> shadows = [];
    if (isSelected) {
      shadows = [
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
            spreadRadius: widget.borderWidth + 2,
          ),
        );
      }
    }

    return BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: widget.borderWidth,
      ),
      boxShadow: shadows,
    );
  }
}
