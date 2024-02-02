import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/game_controller.dart';
import '../model/level.dart';
import '../model/objective.dart';
import 'stream_objective_item.dart';

class ObjectivePanel extends StatelessWidget {
  const ObjectivePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = RepositoryProvider.of<GameController>(context);
    final Level level = gameController.levelNtf.value!;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final EdgeInsets paddingTop = EdgeInsets.only(
        top: (orientation == Orientation.portrait ? 10.0 : 0.0));
    //
    // Build the objectives
    //
    final objectiveWidgets = level.objectives.map((Objective obj) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: StreamObjectiveItem(objective: obj),
      );
    }).toList();

    return Padding(
      padding: paddingTop,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 5.0, color: Colors.black.withOpacity(0.5)),
        ),
        height: 80.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: objectiveWidgets,
        ),
      ),
    );
  }
}
