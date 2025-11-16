# Easy Spin Wheel

A customizable, stateless Flutter package for creating beautiful spin wheel experiences with animations, confetti effects, and various reward configurations. Pure callback-based API with no state management overhead.

## Features

- 🎯 **Stateless & Callback-Based**: No GetX or state management needed, pure callbacks
- 🎨 **Beautiful Animations**: Smooth fade-in, scale animations during spin
- 🎊 **Confetti Effects**: Celebrate wins with colorful confetti animations
- ✨ **Particle Background**: Animated star particles for mystical atmosphere
- 🎭 **Flexible Configuration**: Customize colors, sizes, durations, and more
- 📱 **Easy Integration**: Simple dialog API for quick implementation
- 🎁 **Result Handling**: Callback pattern returns complete reward information

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_spin_wheel:
    path: packages/easy_spin_wheel
```

Or from pub.dev:

```yaml
dependencies:
  easy_spin_wheel: ^1.0.0
```

## Basic Usage

```dart
import 'package:easy_spin_wheel/easy_spin_wheel.dart';

// Simple usage with default rewards
final result = await showEasySpinWheel(
  context: context,
  config: SpinWheelConfig.defaultConfig(
    rewardValues: [10, 25, 50, 100],
  ),
);

if (result != null) {
  print("Won: ${result.reward.value}");
}
```

## Custom Rewards Usage

```dart
final result = await showEasySpinWheel(
  context: context,
  config: SpinWheelConfig.withCustomRewards(
    rewards: [
      SpinWheelReward.simple(
        value: 50,
        label: "50 Coins",
        icon: "🪙",
        isSpecial: false,
      ),
      SpinWheelReward.simple(
        value: 100,
        label: "Jackpot!",
        icon: "🎰",
        isSpecial: true,
      ),
      SpinWheelReward(
        value: 25,
        label: "Bonus",
        icon: "🎁",
        startColor: Colors.purple.shade400,
        endColor: Colors.purple.shade800,
        isSpecial: false,
      ),
    ],
  ),
);

if (result != null) {
  print("Custom reward won: ${result.reward.label}");
}
```

## Advanced Usage

```dart
final result = await showEasySpinWheel(
  context: context,
  config: SpinWheelConfig(
    rewards: [
      SpinWheelReward(
        value: 10,
        label: "10 Coins",
        icon: "⭐",
        startColor: Colors.red.shade400,
        endColor: Colors.red.shade700,
      ),
      SpinWheelReward(
        value: 25,
        label: "25 Coins",
        icon: "💎",
        startColor: Colors.blue.shade400,
        endColor: Colors.blue.shade800,
      ),
      // Add more rewards...
    ],
    spinDuration: Duration(seconds: 3),
    confettiDuration: Duration(seconds: 2),
    wheelSize: 350.0,
    glowIntensity: 0.5,
    confettiColors: [Colors.red, Colors.blue, Colors.green],
    backgroundStartColor: Color(0xFF1a1a2e),
    backgroundEndColor: Color(0xFF0f3460),
    showParticles: true,
    particleCount: 25,
    barrierDismissible: false,
  ),
  animationConfig: SpinWheelAnimationConfig(
    fadeInDuration: Duration(milliseconds: 800),
    spinScaleDuration: Duration(milliseconds: 1500),
    spinScaleFactor: 1.15,
  ),
);

if (result != null) {
  // Handle the result
  print("Reward: ${result.reward.value}");
  print("Index: ${result.index}");
}
```

## Dialog API

### showEasySpinWheel()

Shows the spin wheel as a full-screen dialog and returns the result.

```dart
Future<SpinWheelResult?> showEasySpinWheel({
  required BuildContext context,
  required SpinWheelConfig config,
  SpinWheelAnimationConfig animationConfig = const SpinWheelAnimationConfig(),
  RouteSettings? routeSettings,
})
```

**Returns**: `SpinWheelResult?` - The selected reward or null if dismissed

**SpinWheelResult** contains:
- `reward`: The `SpinWheelReward` that was won
- `index`: The index of the reward in the rewards list

## Configuration Options

### SpinWheelConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `rewards` | `List<SpinWheelReward>` | Required | List of reward items |
| `spinDuration` | `Duration` | `5 seconds` | How long the spin animation lasts |
| `confettiDuration` | `Duration` | `3 seconds` | How long confetti animation lasts |
| `wheelSize` | `double` | `300.0` | Size of the spin wheel |
| `glowIntensity` | `double` | `0.3` | Intensity of glow effects (0.0-1.0) |
| `confettiColors` | `List<Color>` | Rainbow colors | Colors for confetti particles |
| `backgroundStartColor` | `Color` | Dark blue | Background gradient start color |
| `backgroundEndColor` | `Color` | Darker blue | Background gradient end color |
| `showParticles` | `bool` | `true` | Show animated background particles |
| `particleCount` | `int` | `20` | Number of background particles |
| `barrierDismissible` | `bool` | `false` | Allow dismissing dialog by tapping outside |

### SpinWheelAnimationConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `fadeInDuration` | `Duration` | `1000ms` | Page fade-in animation duration |
| `spinScaleDuration` | `Duration` | `2000ms` | Spin scale animation duration |
| `spinScaleFactor` | `double` | `1.1` | How much the wheel scales during spin |
| `fadeInCurve` | `Curve` | `easeInOut` | Fade-in animation curve |
| `spinScaleCurve` | `Curve` | `elasticInOut` | Spin scale animation curve |

### SpinWheelReward

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `int` | Required | Numerical value of the reward |
| `label` | `String` | Required | Display text for the reward |
| `icon` | `String?` | Optional | Emoji or icon for the reward (shown next to label) |
| `startColor` | `Color` | Auto-assigned | Gradient start color |
| `endColor` | `Color` | Auto-assigned | Gradient end color |
| `isSpecial` | `bool` | `false` | Whether this is a special reward (gold colors) |

**Visual Layout**: Icon (if provided) + Label displayed horizontally in each wheel segment.

#### Factory Methods

- `SpinWheelReward.simple()`: Creates reward with auto-assigned colors
- `SpinWheelReward()`: Full constructor for complete customization

## Examples

Check out the `example/` directory for complete working examples.

## Migration from Older Versions

If you were using the old GetX-based API with `EasySpinWheelPage` and `EasySpinWheelController`:

### Before (Old API)
```dart
class SpinWheelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasySpinWheelPage(
      config: SpinWheelConfig.defaultConfig(
        rewardValues: [10, 25, 50, 100],
        onSpinComplete: (reward) {
          print("Won: $reward");
        },
      ),
    );
  }
}
```

### After (New Dialog API)
```dart
class SpinWheelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await showEasySpinWheel(
          context: context,
          config: SpinWheelConfig.defaultConfig(
            rewardValues: [10, 25, 50, 100],
          ),
        );
        
        if (result != null) {
          print("Won: ${result.reward.value}");
        }
      },
      child: const Text('Spin'),
    );
  }
}
```

## Benefits of the New API

✅ **No State Management Overhead**: Pure stateful widget, no GetX required
✅ **Cleaner Callback Pattern**: Result returned as Future
✅ **Type-Safe Results**: `SpinWheelResult` object with all reward info
✅ **Easier Testing**: No GetX controller lifecycle to manage
✅ **Better Memory Management**: Dialog automatically cleans up after completion

## License

MIT License - see LICENSE file for details.
