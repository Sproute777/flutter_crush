import 'package:flutter/material.dart';

import '../model/level.dart';
import '../model/objective.dart';
import 'double_curved_container.dart';
import 'objective_item.dart';

class GameSplash extends StatefulWidget {
  const GameSplash({
    super.key,
    required this.levelNtf,
    this.onComplete,
  });

  final ValueNotifier<Level?> levelNtf;
  final VoidCallback? onComplete;

  @override
  GameSplashState createState() => GameSplashState();
}

class GameSplashState extends State<GameSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationAppear;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
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

    //
    // Build the objectives
    //
    final objectiveWidgets =
        widget.levelNtf.value!.objectives.map((Objective obj) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ObjectiveItem(objective: obj, levelNtf: widget.levelNtf),
      );
    }).toList();

    return AnimatedBuilder(
      animation: _animationAppear,
      child: Material(
        color: Colors.transparent,
        child: DoubleCurvedContainer(
          width: screenSize.width,
          height: 150.0,
          outerColor: Colors.blue[700]!,
          innerColor: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Level:  ${widget.levelNtf.value!.id.index}',
                  style: const TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: objectiveWidgets,
                ),
              ],
            ),
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
