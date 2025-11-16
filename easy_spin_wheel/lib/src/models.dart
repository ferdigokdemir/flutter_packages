import 'package:flutter/material.dart';

/// Spin wheel reward model
class SpinWheelReward {
  final int value;
  final String label;
  final String? icon;
  final Color startColor;
  final Color endColor;
  final bool isSpecial;

  const SpinWheelReward({
    required this.value,
    required this.label,
    this.icon,
    required this.startColor,
    required this.endColor,
    this.isSpecial = false,
  });

  factory SpinWheelReward.simple({
    required int value,
    required String label,
    String? icon,
    bool isSpecial = false,
  }) {
    // Otomatik renk atama (varsayılan renkler)
    Color startColor;
    Color endColor;

    if (isSpecial) {
      startColor = Colors.yellow.shade500;
      endColor = Colors.yellow.shade900;
    } else {
      // Value'ya göre renk atama
      final colors = [
        Colors.red.shade400,
        Colors.blue.shade400,
        Colors.green.shade400,
        Colors.teal.shade400,
        Colors.purple.shade400,
        Colors.orange.shade400,
        Colors.pink.shade400,
        Colors.indigo.shade400,
      ];
      final index = value % colors.length;
      startColor = colors[index];
      endColor = Color.lerp(colors[index], Colors.black, 0.3) ??
          colors[index].withValues(alpha: 0.7);
    }

    return SpinWheelReward(
      value: value,
      label: label,
      icon: icon,
      startColor: startColor,
      endColor: endColor,
      isSpecial: isSpecial,
    );
  }
}

/// Spin wheel result model
class SpinWheelResult {
  final SpinWheelReward reward;
  final int index;

  const SpinWheelResult({
    required this.reward,
    required this.index,
  });
}

/// Spin wheel configuration
class SpinWheelConfig {
  final List<SpinWheelReward> rewards;
  final Duration spinDuration;
  final Duration confettiDuration;
  final double wheelSize;
  final double glowIntensity;
  final List<Color> confettiColors;
  final Color backgroundStartColor;
  final Color backgroundEndColor;
  final bool showParticles;
  final int particleCount;
  final bool barrierDismissible;

  const SpinWheelConfig({
    required this.rewards,
    this.spinDuration = const Duration(seconds: 5),
    this.confettiDuration = const Duration(seconds: 3),
    this.wheelSize = 300.0,
    this.glowIntensity = 0.3,
    this.confettiColors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ],
    this.backgroundStartColor = Colors.black87,
    this.backgroundEndColor = Colors.black54,
    this.showParticles = true,
    this.particleCount = 20,
    this.barrierDismissible = false,
  });

  factory SpinWheelConfig.defaultConfig({
    required List<int> rewardValues,
    Duration? spinDuration,
    Duration? confettiDuration,
    double? wheelSize,
    bool barrierDismissible = false,
  }) {
    final rewards = rewardValues.map((value) {
      String icon;
      switch (value) {
        case 10:
          icon = '⭐';
          break;
        case 25:
          icon = '💎';
          break;
        case 50:
          icon = '🪙';
          break;
        case 60:
          icon = '🔮';
          break;
        case 75:
          icon = '✨';
          break;
        case 80:
          icon = '🌟';
          break;
        case 90:
          icon = '🎭';
          break;
        case 100:
          icon = '👑';
          break;
        default:
          icon = '🎁';
      }
      return SpinWheelReward.simple(
        value: value,
        label: '$value Coins',
        icon: icon,
        isSpecial: value == 100,
      );
    }).toList();

    return SpinWheelConfig(
      rewards: rewards,
      spinDuration: spinDuration ?? const Duration(seconds: 5),
      confettiDuration: confettiDuration ?? const Duration(seconds: 3),
      wheelSize: wheelSize ?? 300.0,
      barrierDismissible: barrierDismissible,
    );
  }

  factory SpinWheelConfig.withCustomRewards({
    required List<SpinWheelReward> rewards,
    Duration? spinDuration,
    Duration? confettiDuration,
    double? wheelSize,
    bool barrierDismissible = false,
  }) {
    return SpinWheelConfig(
      rewards: rewards,
      spinDuration: spinDuration ?? const Duration(seconds: 5),
      confettiDuration: confettiDuration ?? const Duration(seconds: 3),
      wheelSize: wheelSize ?? 300.0,
      barrierDismissible: barrierDismissible,
    );
  }

  SpinWheelConfig copyWith({
    List<SpinWheelReward>? rewards,
    Duration? spinDuration,
    Duration? confettiDuration,
    double? wheelSize,
    double? glowIntensity,
    List<Color>? confettiColors,
    Color? backgroundStartColor,
    Color? backgroundEndColor,
    bool? showParticles,
    int? particleCount,
    bool? barrierDismissible,
  }) {
    return SpinWheelConfig(
      rewards: rewards ?? this.rewards,
      spinDuration: spinDuration ?? this.spinDuration,
      confettiDuration: confettiDuration ?? this.confettiDuration,
      wheelSize: wheelSize ?? this.wheelSize,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      confettiColors: confettiColors ?? this.confettiColors,
      backgroundStartColor: backgroundStartColor ?? this.backgroundStartColor,
      backgroundEndColor: backgroundEndColor ?? this.backgroundEndColor,
      showParticles: showParticles ?? this.showParticles,
      particleCount: particleCount ?? this.particleCount,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    );
  }
}

/// Spin wheel animation settings
class SpinWheelAnimationConfig {
  final Duration fadeInDuration;
  final Duration spinScaleDuration;
  final double spinScaleFactor;
  final Curve fadeInCurve;
  final Curve spinScaleCurve;

  const SpinWheelAnimationConfig({
    this.fadeInDuration = const Duration(milliseconds: 1000),
    this.spinScaleDuration = const Duration(milliseconds: 2000),
    this.spinScaleFactor = 1.1,
    this.fadeInCurve = Curves.easeInOut,
    this.spinScaleCurve = Curves.elasticInOut,
  });
}
