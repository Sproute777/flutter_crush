import 'package:flutter_crush/model/combo.dart';
import 'package:flutter_crush/model/tile.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AnimationComboCollapse extends StatefulWidget {
  AnimationComboCollapse({
    Key? key,
    required this.combo,
    required this.resultingTile,
    required this.onComplete,
  }):super(key: key);

  final Combo combo;
  final VoidCallback onComplete;
  final TileOld resultingTile;

  @override
  _AnimationComboCollapseState createState() => _AnimationComboCollapseState();
}

class _AnimationComboCollapseState extends State<AnimationComboCollapse> with SingleTickerProviderStateMixin {
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
          widget.onComplete();
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
    final double destinationX = widget.resultingTile.location.x;
    final double destinationY = widget.resultingTile.location.y;
  //  Logger.root.warning('build animation combo');
    // Tiles are collapsing at the position of the resulting tile
    List<Widget> children = widget.combo.tiles.map((TileOld? tile){
      if(tile == null){
        return Positioned(child: SizedBox());
      }
      return Positioned(
          left: tile.location.x + (1.0 - _controller.value) * (tile.location.x - destinationX),
          top: tile.location.y + (1.0 - _controller.value) * (destinationY - tile.location.y),
          child: Transform.scale(
            scale: 1.0 - _controller.value,
            child: tile.widget,
          ),
        );
    }).toList();

    // Display the resulting tile
    children. add(
      Positioned(
        left: destinationX,
        top: destinationY,
        child: Transform.scale(
          scale: _controller.value,
          child: widget.resultingTile.widget,
        ),
      ),
    );
    return Stack(
      children: children,
    );
  }
}