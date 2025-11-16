import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'models.dart';

/// Easy Spin Wheel Dialog - Callback-based stateless API
class EasySpinWheel extends StatefulWidget {
  final SpinWheelConfig config;
  final SpinWheelAnimationConfig animationConfig;
  final ValueChanged<SpinWheelResult> onComplete;

  const EasySpinWheel({
    super.key,
    required this.config,
    required this.onComplete,
    this.animationConfig = const SpinWheelAnimationConfig(),
  });

  @override
  State<EasySpinWheel> createState() => _EasySpinWheelState();
}

class _EasySpinWheelState extends State<EasySpinWheel>
    with TickerProviderStateMixin {
  // Animation Controllers
  AnimationController? _fadeController;
  Animation<double>? _fadeAnimation;

  // Confetti Controller
  ConfettiController? _confettiController;

  // State
  bool _isSpinning = false;
  bool _showConfetti = false;
  StreamController<int>? _wheelController;

  // Background particles
  List<Widget> _particles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wheelController == null) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _wheelController = StreamController<int>();

    // Fade animation
    _fadeController = AnimationController(
      duration: widget.animationConfig.fadeInDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: widget.animationConfig.fadeInCurve,
    ));

    // Confetti controller
    _confettiController = ConfettiController(
      duration: widget.config.confettiDuration,
    );

    // Start fade in animation
    _fadeController!.forward();

    // Generate background particles
    if (widget.config.showParticles) {
      _generateParticles();
    }
  }

  void _generateParticles() {
    _particles = List.generate(widget.config.particleCount, (index) {
      return _createParticle(index);
    });
  }

  Widget _createParticle(int index) {
    final random = Random(index);
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: random.nextDouble() * screenSize.width,
      top: random.nextDouble() * screenSize.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.4, end: 0.8),
        duration: Duration(milliseconds: 2000 + (index * 100)),
        builder: (context, value, child) {
          return Opacity(
            opacity: _isSpinning ? value : 0.4,
            child: Text(
              '✨',
              style: TextStyle(
                fontSize: 12 + (index % 3) * 4,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          );
        },
      ),
    );
  }

  void _spin() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    final random = Random();
    final index = random.nextInt(widget.config.rewards.length);

    // Spin the wheel
    _wheelController?.add(index);

    // Complete spin after duration
    Future.delayed(widget.config.spinDuration, () {
      final result = SpinWheelResult(
        reward: widget.config.rewards[index],
        index: index,
      );

      setState(() {
        _isSpinning = false;
      });

      // Show confetti
      setState(() {
        _showConfetti = true;
      });
      _confettiController?.play();

      // Wait for confetti to finish, then close dialog
      Future.delayed(widget.config.confettiDuration, () {
        widget.onComplete(result);
      });
    });
  }

  @override
  void dispose() {
    _wheelController?.close();
    _fadeController?.dispose();
    _confettiController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeAnimation == null ||
        _wheelController == null ||
        _confettiController == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        children: [
          // Background particles
          ..._particles,

          // Main content with animations
          FadeTransition(
            opacity: _fadeAnimation!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spin wheel container
                SizedBox(
                  width: widget.config.wheelSize + 20,
                  height: widget.config.wheelSize + 20,
                  child: Center(
                    child: SizedBox(
                      width: widget.config.wheelSize,
                      height: widget.config.wheelSize,
                      child: FortuneWheel(
                        animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: widget.config.spinDuration,
                          curve: Curves.decelerate,
                        ),
                        onFling: () {
                          if (!_isSpinning) {
                            _spin();
                          }
                        },
                        selected: _wheelController!.stream,
                        items: widget.config.rewards
                            .map(_buildFortuneItem)
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti effect
          if (_showConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController!,
                blastDirection: pi / 2, // Downward
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                shouldLoop: false,
                colors: widget.config.confettiColors,
              ),
            ),
        ],
      ),
    );
  }

  FortuneItem _buildFortuneItem(SpinWheelReward reward) {
    return FortuneItem(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [reward.startColor, reward.endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: reward.startColor.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reward.icon != null)
                Text(
                  reward.icon!,
                  style: const TextStyle(fontSize: 24),
                ),
              if (reward.icon != null) const SizedBox(width: 8),
              Text(
                reward.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      style: FortuneItemStyle(
        color: Colors.transparent,
        borderColor: Colors.white.withValues(alpha: 0.5),
        borderWidth: reward.isSpecial ? 3 : 2,
        textStyle: const TextStyle(
          shadows: [
            Shadow(
              color: Colors.black45,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}
