import 'package:flutter/material.dart';

import '../model/level.dart';
import '../model/objective.dart';
import '../model/tile.dart';

class ObjectiveItem extends StatelessWidget {
  const ObjectiveItem({
    super.key,
    required this.objective,
    required this.levelNtf,
  });

  final Objective objective;
  final ValueNotifier<Level?> levelNtf;

  @override
  Widget build(BuildContext context) {
    //
    // Trick to get the image of the tile
    //
    final TileOld tile = TileOld(type: objective.type, levelNtf: levelNtf);
    tile.build();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: tile.widget,
        ),
        Text('${objective.count}', style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
