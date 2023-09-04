import 'package:flutter_crush/model/combo.dart';
import 'package:flutter_crush/model/tile.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AnimationComboThree extends StatefulWidget {
  AnimationComboThree({
    Key? key,
    required this.combo,
    this.onComplete,
  }):super(key: key);

  final Combo combo;
  final VoidCallback? onComplete;

  @override
  _AnimationComboThreeState createState() => _AnimationComboThreeState();
}

class _AnimationComboThreeState extends State<AnimationComboThree> with SingleTickerProviderStateMixin {
 late final AnimationController _controller;

  @override
  void initState(){
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this)
    ..addListener((){
      setState((){});
    })
    ..addStatusListener((AnimationStatus status){
      if (status == AnimationStatus.completed){
        if (widget.onComplete != null){
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
  //  Logger.root.warning('build animation combo three');
    return Stack(
      children: widget.combo.tiles.map((TileOld? tile){
        if(tile == null){
          return Positioned(child: SizedBox());
        }
        return Positioned(
          left: tile.location.x,
          top: tile.location.y,
          child: Transform.scale(
            scale: 1.0 - _controller.value,
            child: tile.widget,
          ),
        );
      }).toList(),
    );
  }
}