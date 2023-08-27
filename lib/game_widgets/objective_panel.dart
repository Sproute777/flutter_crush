import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crush/game_widgets/stream_objective_item.dart';
import 'package:flutter_crush/model/level.dart';
import 'package:flutter_crush/model/objective.dart';
import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';

class ObjectivePanel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final  gameController = RepositoryProvider.of<GameController>(context);
    final Level level = gameController.levelNtf.value!;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final EdgeInsets paddingTop = EdgeInsets.only(top: (orientation == Orientation.portrait ? 10.0 : 0.0));
    //
    // Build the objectives
    //
    List<Widget> objectiveWidgets = level.objectives.map((Objective obj){
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