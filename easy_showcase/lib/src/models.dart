import 'package:super_tooltip/super_tooltip.dart';
import 'package:flutter/material.dart';

enum ShowcaseAnimation {
  fadeIn,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  bounce,
  scale,
  rotate,
}

enum ShowcaseDismissType {
  tap,
  swipe,
  auto,
  none,
}

class ShowcaseConfig {
  final String key;
  final SuperTooltipController controller;
  final bool isShown;
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

  const ShowcaseConfig({
    required this.key,
    required this.controller,
    this.isShown = false,
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
  });
}

class ShowcaseTheme {
  final Color primaryColor;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? overlayColor;
  final Color? highlightColor;

  const ShowcaseTheme({
    this.primaryColor = Colors.blue,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black87,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.titleStyle,
    this.descriptionStyle,
    this.overlayColor,
    this.highlightColor,
  });
}

class ShowcaseAnalytics {
  final String eventName;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  const ShowcaseAnalytics({
    required this.eventName,
    this.parameters = const {},
    required this.timestamp,
  });
}

class ShowcaseSequence {
  final List<String> keys;
  final Duration delayBetween;
  final bool loop;
  final VoidCallback? onComplete;
  final VoidCallback? onStep;

  const ShowcaseSequence({
    required this.keys,
    this.delayBetween = const Duration(milliseconds: 500),
    this.loop = false,
    this.onComplete,
    this.onStep,
  });
}
