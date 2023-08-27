import 'package:flutter_crush/model/level.dart';
import 'package:flutter_crush/model/objective.dart';
import 'package:flutter_crush/model/tile.dart';
import 'package:flutter/material.dart';

class ObjectiveItem extends StatelessWidget {
  ObjectiveItem({
    Key? key,
    required this.objective,
    required this.levelNtf,
  }): super(key: key);

  final Objective objective;
  final ValueNotifier<Level?> levelNtf;

  @override
  Widget build(BuildContext context) {
    //
    // Trick to get the image of the tile
    //
    TileOld tile = TileOld(type: objective.type, levelNtf: levelNtf);
    tile.build();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 32.0,
            height: 32.0,
            child: tile.widget,
          ),
          Text('${objective.count}', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}