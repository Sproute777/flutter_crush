import 'package:flutter/material.dart';

import '../model/tile.dart';

class AnimationSwapTiles extends StatefulWidget {
  const AnimationSwapTiles({
    super.key,
    required this.upTile,
    required this.downTile,
    this.onComplete,
    required this.swapAllowed,
  });

  final TileOld upTile;
  final TileOld downTile;
  final VoidCallback? onComplete;
  final bool swapAllowed;

  @override
  AnimationSwapTilesState createState() => AnimationSwapTilesState();
}

class AnimationSwapTilesState extends State<AnimationSwapTiles> with SingleTickerProviderStateMixin {
 late final AnimationController _controller;

  @override
  void initState(){
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
      setState(() {});
    })..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (!widget.swapAllowed){
          _controller.reverse();
        } else {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      }

      if (status == AnimationStatus.dismissed){
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
      }
    });

    _controller.forward();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deltaX = widget.upTile.location.x - widget.downTile.location.x;
    final double deltaY = widget.upTile.location.y - widget.downTile.location.y;


  //  Logger.root.warning('build animation swap tiles');
    return Stack(
      children: <Widget>[
        Positioned(
          left: widget.downTile.location.x + deltaX * _controller.value,
          top: widget.downTile.location.y + deltaY * _controller.value,
          child: widget.downTile.widget,
        ),
        Positioned(
          left: widget.upTile.location.x - deltaX * _controller.value,
          top: widget.upTile.location.y - deltaY * _controller.value,
          child: widget.upTile.widget,
        ),
      ],
    );
  }
}
