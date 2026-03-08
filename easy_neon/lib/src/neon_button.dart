import 'package:flutter/material.dart';

/// Neon buton şekilleri
enum NeonShape {
  /// Dairesel buton (SpinWheel, AdWatch gibi)
  circle,

  /// Yuvarlatılmış köşeli buton (Start butonu gibi)
  rounded,
}

/// Basma efekti türleri
enum NeonPressEffect {
  /// Küçülme efekti
  scale,

  /// Glow artışı efekti
  glow,

  /// Zıplama efekti
  bounce,

  /// Efekt yok
  none,
}

/// 🌟 Neon efektli buton widget'ı
///
/// Üç farklı kullanım senaryosu destekler:
/// - Dairesel ikonlu butonlar (SpinWheel, AdWatch)
/// - Rounded dikdörtgen butonlar (Start Game)
///
/// Örnek kullanım:
/// ```dart
/// NeonButton(
///   neonColor: Color(0xFFFFD700),
///   shape: NeonShape.circle,
///   width: 72,
///   height: 72,
///   onTap: () => print('tapped'),
///   pulse: true,
///   badge: '3',
///   child: Icon(Icons.star),
/// )
/// ```
class NeonButton extends StatefulWidget {
  const NeonButton({
    super.key,
    required this.neonColor,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.isEnabled = true,
    this.shape = NeonShape.rounded,
    this.width,
    this.height,
    this.borderWidth = 2.0,
    this.glowIntensity = 0.6,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.disabledColor,
    // Görsel efektler
    this.pulse = false,
    this.shimmer = false,
    this.doubleBorder = false,
    this.neonGradient,
    this.innerGlow = false,
    // Animasyon
    this.scaleOnPress = 0.95,
    this.pressEffect = NeonPressEffect.scale,
    this.hoverGlowMultiplier = 1.3,
    this.animateIn = false,
    // Fonksiyonel
    this.isLoading = false,
    this.badge,
    this.badgeColor,
    this.tooltip,
    this.semanticLabel,
  });

  /// Neon efekti için kullanılacak ana renk
  final Color neonColor;

  /// Butonun içeriği (icon, text, veya özel widget)
  final Widget child;

  /// Tıklama callback'i
  final VoidCallback? onTap;

  /// Uzun basma callback'i
  final VoidCallback? onLongPress;

  /// Buton aktif mi? false ise glow efekti kapalı ve onTap çalışmaz
  final bool isEnabled;

  /// Buton şekli: circle veya rounded
  final NeonShape shape;

  /// Buton genişliği (null ise içeriğe göre)
  final double? width;

  /// Buton yüksekliği (null ise içeriğe göre)
  final double? height;

  /// Border kalınlığı
  final double borderWidth;

  /// Glow efekti yoğunluğu (0.0 - 1.0 arası)
  final double glowIntensity;

  /// Opsiyonel gradient (isEnabled true ise kullanılır)
  final Gradient? gradient;

  /// Border radius (sadece rounded shape için)
  final double? borderRadius;

  /// İçerik padding'i
  final EdgeInsets? padding;

  /// Disabled durumda kullanılacak renk
  final Color? disabledColor;

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

  /// Basınca küçülme oranı (1.0 = değişim yok, 0.9 = %10 küçülme)
  final double scaleOnPress;

  /// Basma efekti türü
  final NeonPressEffect pressEffect;

  /// Hover'da glow çarpanı
  final double hoverGlowMultiplier;

  /// İlk görünümde animasyon
  final bool animateIn;

  // ─── Fonksiyonel ───

  /// Loading durumu - spinner gösterir
  final bool isLoading;

  /// Sağ üst köşe badge metni
  final String? badge;

  /// Badge arka plan rengi
  final Color? badgeColor;

  /// Tooltip metni
  final String? tooltip;

  /// Accessibility için semantik etiket
  final String? semanticLabel;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late AnimationController _entryController;
  late AnimationController _shimmerController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _pressAnimation;
  late Animation<double> _entryAnimation;
  late Animation<double> _shimmerAnimation;

  bool _isPressed = false;
  bool _isHovered = false;

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
    if (widget.pulse && widget.isEnabled) {
      _pulseController.repeat(reverse: true);
    }

    // Press animasyonu
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressAnimation =
        Tween<double>(begin: 1.0, end: widget.scaleOnPress).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );

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
    if (widget.shimmer && widget.isEnabled) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(NeonButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pulse kontrolü
    if (widget.pulse && widget.isEnabled && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if ((!widget.pulse || !widget.isEnabled) &&
        _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    // Shimmer kontrolü
    if (widget.shimmer && widget.isEnabled && !_shimmerController.isAnimating) {
      _shimmerController.repeat();
    } else if ((!widget.shimmer || !widget.isEnabled) &&
        _shimmerController.isAnimating) {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    if (widget.pressEffect == NeonPressEffect.scale ||
        widget.pressEffect == NeonPressEffect.bounce) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    if (widget.pressEffect == NeonPressEffect.bounce) {
      _pressController.reverse().then((_) {
        _pressController.forward().then((_) => _pressController.reverse());
      });
    } else {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isEnabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDisabledColor = widget.disabledColor ?? Colors.grey.shade600;
    final effectiveBorderRadius = widget.borderRadius ?? 30.0;

    Widget buttonContent = _buildButtonContent(
      effectiveDisabledColor,
      effectiveBorderRadius,
    );

    // Entry animasyonu
    if (widget.animateIn) {
      buttonContent = ScaleTransition(
        scale: _entryAnimation,
        child: buttonContent,
      );
    }

    // Press scale animasyonu
    if (widget.pressEffect == NeonPressEffect.scale ||
        widget.pressEffect == NeonPressEffect.bounce) {
      buttonContent = AnimatedBuilder(
        animation: _pressAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _pressAnimation.value, child: child);
        },
        child: buttonContent,
      );
    }

    // Tooltip
    if (widget.tooltip != null) {
      buttonContent = Tooltip(
        message: widget.tooltip!,
        child: buttonContent,
      );
    }

    // Semantics
    if (widget.semanticLabel != null) {
      buttonContent = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: widget.isEnabled,
        child: buttonContent,
      );
    }

    return buttonContent;
  }

  Widget _buildButtonContent(
    Color effectiveDisabledColor,
    double effectiveBorderRadius,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isEnabled && !widget.isLoading ? widget.onTap : null,
        onLongPress:
            widget.isEnabled && !widget.isLoading ? widget.onLongPress : null,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Ana buton
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: widget.width,
                  height: widget.height,
                  padding: widget.padding,
                  decoration: _buildDecoration(
                    effectiveDisabledColor,
                    effectiveBorderRadius,
                  ),
                  child: Stack(
                    children: [
                      // Shimmer efekti
                      if (widget.shimmer && widget.isEnabled)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: widget.shape == NeonShape.circle
                                ? BorderRadius.circular(1000)
                                : BorderRadius.circular(effectiveBorderRadius),
                            child: _buildShimmerOverlay(),
                          ),
                        ),

                      // İçerik veya Loading
                      Center(
                        child: widget.isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.isEnabled
                                        ? widget.neonColor
                                        : effectiveDisabledColor,
                                  ),
                                ),
                              )
                            : widget.child,
                      ),
                    ],
                  ),
                ),

                // Badge
                if (widget.badge != null) _buildBadge(),
              ],
            );
          },
        ),
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
      top: -6,
      right: -6,
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

  BoxDecoration _buildDecoration(
    Color effectiveDisabledColor,
    double effectiveBorderRadius,
  ) {
    final isCircle = widget.shape == NeonShape.circle;
    final isEnabled = widget.isEnabled;

    // Neon rengi (gradient veya solid)
    final effectiveNeonColor = widget.neonGradient != null && isEnabled
        ? widget.neonGradient!.first
        : widget.neonColor;

    // Glow yoğunluğu (hover ve press efektleri)
    double currentGlowIntensity = widget.glowIntensity;
    if (_isHovered && isEnabled) {
      currentGlowIntensity *= widget.hoverGlowMultiplier;
    }
    if (_isPressed && widget.pressEffect == NeonPressEffect.glow && isEnabled) {
      currentGlowIntensity *= 1.5;
    }

    // Pulse animasyonu glow'a etkisi
    if (widget.pulse && isEnabled) {
      currentGlowIntensity *= _pulseAnimation.value;
    }

    // Arka plan rengi veya gradient
    final backgroundGradient =
        isEnabled && widget.gradient != null ? widget.gradient : null;

    final backgroundColor = isEnabled
        ? (widget.gradient == null
            ? effectiveNeonColor.withValues(alpha: 0.2)
            : null)
        : effectiveDisabledColor.withValues(alpha: 0.2);

    // Border rengi
    Color borderColor;
    if (widget.neonGradient != null && isEnabled) {
      borderColor = widget.neonGradient!.first.withValues(alpha: 0.8);
    } else {
      borderColor = isEnabled
          ? widget.neonColor.withValues(alpha: 0.8)
          : effectiveDisabledColor.withValues(alpha: 0.5);
    }

    // Glow efekti (sadece enabled durumda)
    List<BoxShadow> shadows = [];
    if (isEnabled) {
      shadows = [
        BoxShadow(
          color: effectiveNeonColor.withValues(alpha: currentGlowIntensity),
          blurRadius: 12,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: effectiveNeonColor.withValues(
            alpha: currentGlowIntensity * 0.5,
          ),
          blurRadius: 24,
          spreadRadius: 4,
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
    }

    // Double border efekti
    if (widget.doubleBorder && isEnabled) {
      shadows.add(
        BoxShadow(
          color: effectiveNeonColor.withValues(alpha: 0.4),
          spreadRadius: widget.borderWidth + 3,
        ),
      );
    }

    return BoxDecoration(
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius:
          isCircle ? null : BorderRadius.circular(effectiveBorderRadius),
      color: backgroundGradient == null ? backgroundColor : null,
      gradient: backgroundGradient,
      border: Border.all(
        color: borderColor,
        width: widget.borderWidth,
      ),
      boxShadow: shadows,
    );
  }
}
