import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/game_controller.dart';


class StreamMovesLeftCounter extends StatelessWidget {
  const StreamMovesLeftCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = RepositoryProvider.of<GameController>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.swap_horiz, color: Colors.black,),
        const SizedBox(width: 8.0),
        StreamBuilder<int>(
          initialData: gameController.levelNtf.value!.maxMoves,
          stream: gameController.movesLeftCount,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot){
            return Text('${snapshot.data}', style: const TextStyle(color: Colors.black, fontSize: 16.0,),);
          }
        ),
      ],
    );
  }
}
