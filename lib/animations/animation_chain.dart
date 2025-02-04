import 'package:flutter/material.dart';

import '../model/animation_sequence.dart';
import '../model/level.dart';
import '../model/tile_animation.dart';


class AnimationChain extends StatefulWidget {
  const AnimationChain({
    super.key,
    required this.animationSequence,
    required this.levelNtf,
     required this.onComplete,
  });

  final AnimationSequence animationSequence;
  final VoidCallback onComplete;
  final ValueNotifier<Level?> levelNtf;

  @override
  AnimationChainState createState() => AnimationChainState();
}

class AnimationChainState extends State<AnimationChain> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // List of all individual animations (one per delay)
  final _animations = <Animation<double>>[];
  
  // Normal duration of one fall
  final int normalDurationInMs = 300;

  // Duration of one delay
  final int delayInMs = 10;

  // Total duration, taking into consideration the number of different delays
  late int totalDurationInMs;

  @override
  void initState(){
    super.initState();

    //
    // We need to compute the total duration
    //
    totalDurationInMs = (widget.animationSequence.endDelay + 1) * delayInMs + normalDurationInMs;

    _controller = AnimationController(duration: Duration(milliseconds: totalDurationInMs), vsync: this)
    ..addListener((){
      setState((){});
    })
    ..addStatusListener((AnimationStatus status){
      if (status == AnimationStatus.completed){
          widget.onComplete();
       
      }
    });

    //
    // Let's build the list of all animations in the sequence
    //
    for (final tileAnimation in widget.animationSequence.animations) {
      final int start = tileAnimation.delay * delayInMs;
      final int end = start + normalDurationInMs;
      final double ratioStart = start / totalDurationInMs;
      final double ratioEnd = end / totalDurationInMs;

      _animations.add(
        Tween<double>(begin: 0.0, end: 1.0)
          .animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                ratioStart,
                ratioEnd,
                curve: Curves.ease,
              ),
            ),
          )
      );
    }

    _controller.forward();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TileAnimation firstAnimation = widget.animationSequence.animations[0];
    final int totalAnimations = widget.animationSequence.animations.length;
    int index = totalAnimations - 1;

    Widget? theWidget = firstAnimation.tile?.widget;

    //
    // In order to build the Widgets tree, we need to start from the last one up to the first
    //
    while (index >= 0){
      theWidget = _buildSubAnimationFactory(index, widget.animationSequence.animations[index], theWidget);
      index--;
    }

    return Stack(
      children: [
        Positioned(
          left: firstAnimation.tile?.location.x,
          top: firstAnimation.tile?.location.y,
          child: theWidget ?? const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildSubAnimationFactory(int index, TileAnimation tileAnimation, Widget? childWidget){
    Widget widget;
    switch(tileAnimation.animationType){
        case TileAnimationType.newTile:
          widget = _buildSubAnimationAppearance(index, tileAnimation, childWidget);
        case TileAnimationType.moveDown:
          widget = _buildSubAnimationMoveDown(index, tileAnimation, childWidget);
        case TileAnimationType.avalanche:
          widget = _buildSubAnimationSlide(index, tileAnimation, childWidget);
        case TileAnimationType.collapse:
          widget = _buildSubAnimationCollapse(index, tileAnimation, childWidget);
        case TileAnimationType.chain:
          widget = _buildSubAnimationChain(index, tileAnimation, childWidget);
      }
    return widget;
  }

  //
  // The appearance consists in an initial translated (-Y) position,
  // followed by a move down
  //
  Widget _buildSubAnimationAppearance(int index, TileAnimation tileAnimation, Widget? childWidget){
    return Transform.translate(
      offset: Offset(0.0, -widget.levelNtf.value!.tileHeight + widget.levelNtf.value!.tileHeight * _animations[index].value),
      child: _buildSubAnimationMoveDown(index, tileAnimation, childWidget),
    );
  }

  //
  // A move down animation consists in moving the tile down to its final position
  //
  Widget _buildSubAnimationMoveDown(int index, TileAnimation tileAnimation, Widget? childWidget){
    final double distance = (tileAnimation.to.row - tileAnimation.from.row) * widget.levelNtf.value!.tileHeight;

    return Transform.translate(
      offset: Offset(0.0, -_animations[index].value * distance),
      child: childWidget,
    );
  }

  //
  // A slide consists in moving the tile horizontally
  //
  Widget _buildSubAnimationSlide(int index, TileAnimation tileAnimation, Widget? childWidget){
    final double distanceX = (tileAnimation.to.col - tileAnimation.from.col) * widget.levelNtf.value!.tileWidth;
    final double distanceY = (tileAnimation.to.row - tileAnimation.from.row) * widget.levelNtf.value!.tileHeight;
    return Transform.translate(
      offset: Offset(_animations[index].value * distanceX, -_animations[index].value * distanceY),
      child: childWidget,      
    );
  }

  //
  // A chain consists in making tiles disappear
  //
  Widget _buildSubAnimationChain(int index, TileAnimation tileAnimation, Widget? childWidget){
    return Transform.scale(
      scale: 1.0 - _animations[index].value,
      child: childWidget,      
    );
  }

  //
  // A collapse consists in moving the tile to the destination tile position
  //
  Widget _buildSubAnimationCollapse(int index, TileAnimation tileAnimation, Widget? childWidget){
    final double distanceX = (tileAnimation.to.col - tileAnimation.from.col) * widget.levelNtf.value!.tileWidth;
    final double distanceY = (tileAnimation.to.row - tileAnimation.from.row) * widget.levelNtf.value!.tileHeight;
    return Transform.translate(
      offset: Offset(_animations[index].value * distanceX, -_animations[index].value * distanceY),
      child: childWidget,      
    );
  }

}
