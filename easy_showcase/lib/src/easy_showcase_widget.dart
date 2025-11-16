import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:get/get.dart';
import 'easy_showcase_singleton.dart';
import 'models.dart';

class EasyShowcaseWidget extends StatefulWidget {
  final String showcaseKey;
  final Widget child;
  final String? title;
  final String? description;
  final String? direction;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? arrowBaseWidth;
  final double? arrowLength;
  final ShowcaseAnimation? animation;
  final Duration? animationDuration;
  final bool playSound;
  final bool vibrate;
  final Duration? autoDismiss;
  final ShowcaseDismissType dismissType;
  final bool showOverlay;
  final Color? overlayColor;
  final Color? highlightColor;
  final String? titleKey;
  final String? descriptionKey;
  final Widget? customContent;
  final bool Function()? condition;
  final VoidCallback? onShow;
  final VoidCallback? onHide;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  const EasyShowcaseWidget({
    super.key,
    required this.showcaseKey,
    required this.child,
    this.title,
    this.description,
    this.direction,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.arrowBaseWidth,
    this.arrowLength,
    this.animation,
    this.animationDuration,
    this.playSound = false,
    this.vibrate = false,
    this.autoDismiss,
    this.dismissType = ShowcaseDismissType.tap,
    this.showOverlay = false,
    this.overlayColor,
    this.highlightColor,
    this.titleKey,
    this.descriptionKey,
    this.customContent,
    this.condition,
    this.onShow,
    this.onHide,
    this.titleStyle,
    this.descriptionStyle,
  });

  @override
  State<EasyShowcaseWidget> createState() => _EasyShowcaseWidgetState();
}

class _EasyShowcaseWidgetState extends State<EasyShowcaseWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  TooltipDirection _parseDirection(String? direction) {
    switch (direction?.toLowerCase()) {
      case 'up':
        return TooltipDirection.up;
      case 'down':
        return TooltipDirection.down;
      case 'left':
        return TooltipDirection.left;
      case 'right':
        return TooltipDirection.right;
      default:
        return TooltipDirection.up;
    }
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupConfig();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    switch (widget.animation ?? ShowcaseAnimation.fadeIn) {
      case ShowcaseAnimation.fadeIn:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );
        break;
      case ShowcaseAnimation.slideUp:
        _animation = Tween<double>(begin: 50.0, end: 0.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
        break;
      case ShowcaseAnimation.slideDown:
        _animation = Tween<double>(begin: -50.0, end: 0.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
        break;
      case ShowcaseAnimation.slideLeft:
        _animation = Tween<double>(begin: 50.0, end: 0.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
        break;
      case ShowcaseAnimation.slideRight:
        _animation = Tween<double>(begin: -50.0, end: 0.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
        break;
      case ShowcaseAnimation.bounce:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.bounceOut),
        );
        break;
      case ShowcaseAnimation.scale:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.elasticOut),
        );
        break;
      case ShowcaseAnimation.rotate:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
        break;
    }
  }

  void _setupConfig() {
    final config = ShowcaseConfig(
      key: widget.showcaseKey,
      controller: EasyShowcase.instance.getController(widget.showcaseKey),
      animation: widget.animation,
      animationDuration: widget.animationDuration,
      playSound: widget.playSound,
      vibrate: widget.vibrate,
      autoDismiss: widget.autoDismiss,
      dismissType: widget.dismissType,
      showOverlay: widget.showOverlay,
      overlayColor: widget.overlayColor,
      highlightColor: widget.highlightColor,
      titleKey: widget.titleKey,
      descriptionKey: widget.descriptionKey,
      customContent: widget.customContent,
      condition: widget.condition,
    );
    EasyShowcase.instance.setConfig(widget.showcaseKey, config);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedContent(Widget content) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        switch (widget.animation ?? ShowcaseAnimation.fadeIn) {
          case ShowcaseAnimation.fadeIn:
            return Opacity(
              opacity: _animation.value,
              child: content,
            );
          case ShowcaseAnimation.slideUp:
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: content,
            );
          case ShowcaseAnimation.slideDown:
            return Transform.translate(
              offset: Offset(0, -_animation.value),
              child: content,
            );
          case ShowcaseAnimation.slideLeft:
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: content,
            );
          case ShowcaseAnimation.slideRight:
            return Transform.translate(
              offset: Offset(-_animation.value, 0),
              child: content,
            );
          case ShowcaseAnimation.bounce:
            return Transform.scale(
              scale: _animation.value,
              child: content,
            );
          case ShowcaseAnimation.scale:
            return Transform.scale(
              scale: _animation.value,
              child: content,
            );
          case ShowcaseAnimation.rotate:
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: content,
            );
        }
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.customContent != null) {
      return widget.customContent!;
    }

    final theme = EasyShowcase.globalTheme;
    final title = widget.titleKey ?? widget.title;
    final description = widget.descriptionKey ?? widget.description;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: widget.titleStyle ??
                theme.titleStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: widget.textColor ?? theme.textColor,
                ),
          ),
          const SizedBox(height: 8),
        ],
        if (description != null)
          Text(
            description,
            style: widget.descriptionStyle ??
                theme.descriptionStyle ??
                TextStyle(
                  fontSize: 14,
                  color: widget.textColor ?? theme.textColor,
                ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyShowcase.globalTheme;

    return GestureDetector(
      onTap: () {
        if (widget.dismissType == ShowcaseDismissType.tap) {
          EasyShowcase.instance.hide(widget.showcaseKey);
          widget.onHide?.call();
        }
      },
      child: Stack(
        children: [
          if (widget.showOverlay)
            Container(
              color:
                  widget.overlayColor ?? theme.overlayColor ?? Colors.black54,
            ),
          SuperTooltip(
            controller: EasyShowcase.instance.getController(widget.showcaseKey),
            popupDirection: _parseDirection(widget.direction),
            backgroundColor: widget.backgroundColor ?? theme.backgroundColor,
            borderRadius: widget.borderRadius ?? theme.borderRadius,
            arrowBaseWidth: widget.arrowBaseWidth ?? 8.0,
            arrowLength: widget.arrowLength ?? 8.0,
            content: _buildAnimatedContent(_buildContent(context)),
            onShow: () {
              _animationController.forward();
              widget.onShow?.call();
            },
            onHide: () {
              _animationController.reverse();
              widget.onHide?.call();
            },
            child: Container(
              decoration: widget.highlightColor != null
                  ? BoxDecoration(
                      color: widget.highlightColor,
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// Theme Provider Widget
class EasyShowcaseTheme extends InheritedWidget {
  final ShowcaseTheme theme;

  const EasyShowcaseTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  static ShowcaseTheme of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<EasyShowcaseTheme>();
    return theme?.theme ?? const ShowcaseTheme();
  }

  @override
  bool updateShouldNotify(EasyShowcaseTheme oldWidget) {
    return theme != oldWidget.theme;
  }
}

// Controller for GetX integration
class EasyShowcaseController extends GetxController {
  final Map<String, RxBool> _showcaseStates = {};

  RxBool isShown(String key) {
    if (!_showcaseStates.containsKey(key)) {
      _showcaseStates[key] = false.obs;
    }
    return _showcaseStates[key]!;
  }

  Future<void> show(String key) async {
    await EasyShowcase.instance.showSingle(key);
    _showcaseStates[key]?.value = true;
  }

  Future<void> hide(String key) async {
    await EasyShowcase.instance.hide(key);
    _showcaseStates[key]?.value = false;
  }

  @override
  void onClose() {
    for (var state in _showcaseStates.values) {
      state.close();
    }
    _showcaseStates.clear();
    super.onClose();
  }
}
