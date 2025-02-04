import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/game_controller.dart';
import '../model/level.dart';
import 'stream_moves_left_counter.dart';

class GameMovesLeftPanel extends StatelessWidget {
  const GameMovesLeftPanel({super.key});


  @override
  Widget build(BuildContext context) {
    final  gameController = RepositoryProvider.of<GameController>(context);
    final ValueNotifier<Level?> levelNtf = gameController.levelNtf;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final EdgeInsets paddingTop = EdgeInsets.only(top: (orientation == Orientation.portrait ? 10.0 : 0.0));

    return Padding(
      padding: paddingTop,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 5.0, color: Colors.black.withOpacity(0.5)),
        ),
        width: 100.0,
        height: 80.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Level: ${levelNtf.value?.id.index}',
                style: const TextStyle(fontSize: 14.0, color: Colors.black,)
              ),
            ),
            const StreamMovesLeftCounter(),
          ],
        ),
      ),
    );
  }
}
