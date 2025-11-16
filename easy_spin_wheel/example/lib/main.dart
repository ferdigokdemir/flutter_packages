import 'package:easy_spin_wheel/easy_spin_wheel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Spin Wheel Example',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Spin Wheel Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSpinWheel(context),
          child: const Text('Open Spin Wheel'),
        ),
      ),
    );
  }

  Future<void> _showSpinWheel(BuildContext context) async {
    final result = await showEasySpinWheel(
      context: context,
      config: SpinWheelConfig.withCustomRewards(
        rewards: [
          SpinWheelReward.simple(
            value: 10,
            label: "10",
            icon: "🥉",
          ),
          SpinWheelReward.simple(
            value: 25,
            label: "25",
            icon: "🥈",
          ),
          SpinWheelReward.simple(
            value: 50,
            label: "50",
            icon: "🥇",
          ),
          SpinWheelReward.simple(
            value: 100,
            label: "100",
            icon: "💎",
            isSpecial: true,
          ),
          SpinWheelReward(
            value: 75,
            label: "75",
            icon: "🎁",
            startColor: Colors.purple.shade400,
            endColor: Colors.purple.shade800,
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Congratulations! You won ${result.reward.value} points! 🎉',
          ),
        ),
      );
    }
  }
}
