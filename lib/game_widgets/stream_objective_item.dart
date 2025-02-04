import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../bloc/objective_bloc.dart';
import '../controllers/game_controller.dart';
import '../model/objective.dart';
import '../model/tile.dart';

class StreamObjectiveItem extends StatefulWidget {
  const StreamObjectiveItem({
    super.key,
    required this.objective,
  });

  final Objective objective;

  @override
  StreamObjectiveItemState createState() {
    return StreamObjectiveItemState();
  }
}

class StreamObjectiveItemState extends State<StreamObjectiveItem> {
   late final AimBloc _bloc;
    // GameBloc? gameBloc;
    GameController? gameController;

  ///
  /// In order to determine whether this particular Objective is
  /// part of the list of Objective Events, we need to inject the stream
  /// that gives us the list of all Objective Events to THIS instance
  /// of the BLoC
  ///
  StreamSubscription? _subscription;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    // Now that the context is available, retrieve the gameBloc
    // gameBloc = RepositoryProvider.of<GameBloc>(context);
    gameController = RepositoryProvider.of<GameController>(context);
    _createBloc();
  } 

  ///
  /// As Widgets can be changed by the framework at any time,
  /// we need to make sure that if this happens, we keep on
  /// listening to the stream that notifies us about Objectives
  ///
  @override
  void didUpdateWidget(StreamObjectiveItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose(){
    _disposeBloc();
    super.dispose();
  }

  void _createBloc() {
    _bloc = AimBloc(widget.objective.type);

    // Simple pipe from the stream that lists all the ObjectiveEvents into
    // the BLoC that processes THIS particular Objective type
    _subscription?.cancel();
    _subscription = gameController!.outObjectiveEvents.listen((o) {
      Logger.root.fine(' listen ourObjectiveEvents');
      _bloc.setObjectives(o);
    });
  }

  void _disposeBloc() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    //
    // Trick to get the image of the tile
    //
    final TileOld tile = TileOld(type: widget.objective.type, levelNtf: gameController!.levelNtf);
    tile.build();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: tile.widget,
        ),
        StreamBuilder<int>(
          initialData: widget.objective.count,
          stream: _bloc.objectiveCounter,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot){
            return Text(
              '${snapshot.data}',
              style: const TextStyle(color: Colors.black),
            );
          }
        ),
      ],
    );
  }
}
