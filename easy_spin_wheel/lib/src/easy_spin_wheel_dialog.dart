import 'package:flutter/material.dart';
import 'models.dart';
import 'easy_spin_wheel_widget.dart';

/// Shows the Easy Spin Wheel dialog and returns the result
///
/// Returns [SpinWheelResult] when spin completes, or null if dismissed
///
/// Example:
/// ```dart
/// final result = await showEasySpinWheel(
///   context: context,
///   config: SpinWheelConfig.defaultConfig(
///     rewardValues: [10, 25, 50, 100],
///   ),
/// );
///
/// if (result != null) {
///   print('Won: ${result.reward.value}');
/// }
/// ```
Future<SpinWheelResult?> showEasySpinWheel({
  required BuildContext context,
  required SpinWheelConfig config,
  SpinWheelAnimationConfig animationConfig = const SpinWheelAnimationConfig(),
  RouteSettings? routeSettings,
}) async {
  return await showDialog<SpinWheelResult>(
    context: context,
    barrierDismissible: config.barrierDismissible,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return PopScope(
        canPop: config.barrierDismissible,
        child: Dialog(
          child: Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: SizedBox(
                width: 350,
                height: 350,
                child: EasySpinWheel(
                  config: config,
                  animationConfig: animationConfig,
                  onComplete: (result) {
                    // Close dialog with result after a small delay
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        Navigator.of(context).pop(result);
                      }
                    });
                  },
                ),
              )),
        ),
      );
    },
  );
}
