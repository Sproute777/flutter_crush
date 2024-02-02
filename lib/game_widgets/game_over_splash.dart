import 'package:flutter/material.dart';

import '../model/level.dart';
import 'double_curved_container.dart';

class GameOverSplash extends StatefulWidget {
  const GameOverSplash({
    super.key,
    required this.success,
    required this.level,
    this.onComplete,
  });

  final Level level;
  final VoidCallback? onComplete;
  final bool success;

  @override
  GameOverSplashState createState() => GameOverSplashState();
}

class GameOverSplashState extends State<GameOverSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationAppear;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });

    _animationAppear = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.1,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Play the intro
    // Audio.playAsset(AudioType.game_start);

    // Launch the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final darkColor = widget.success ? Colors.green[700]! : Colors.red[700]!;
    final lightColor = widget.success ? Colors.green : Colors.red;
    final String message = widget.success ? 'You Win' : 'Game Over';

    return AnimatedBuilder(
      animation: _animationAppear,
      child: Material(
        color: Colors.transparent,
        child: DoubleCurvedContainer(
          width: screenSize.width,
          height: 150.0,
          outerColor: darkColor,
          innerColor: lightColor,
          child: Center(
            child: Text(message,
                style: const TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          left: 0.0,
          top: 150.0 + 100.0 * _animationAppear.value,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
