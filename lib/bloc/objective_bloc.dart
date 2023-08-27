import 'dart:async';

import 'package:flutter_crush/model/objective_event.dart';
import 'package:flutter_crush/model/tile.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class ObjectiveBloc {
  ///
  /// A stream only meant to return whether THIS objective type is part of the Objective events
  ///
  final BehaviorSubject<int> _objectiveCounterController =
      BehaviorSubject<int>();
  Stream<int> get objectiveCounter => _objectiveCounterController.stream;

  ///
  /// Stream of all the Objective events
  ///
  final StreamController<ObjectiveEvent> _objectivesController =
      StreamController<ObjectiveEvent>();
  // Function get sendObjectives => _objectivesController.sink.add;
  void setObjectives(ObjectiveEvent event) =>
      _objectivesController.sink.add(event);

  ///
  /// Constructor
  ///
  ObjectiveBloc(TileType tileType) {
    //
    // We are listening to all Objective events
    //
    _objectivesController.stream
        // but, we only consider the ones that matches THIS one
        .where((e) {
          Logger.root.fine('objectiveCtr type ${e.type} ${tileType}');
          return e.type == tileType;
        })
        // if any, we emit the corresponding counter
        .listen((event) {
          Logger.root.fine('objectiveCtr ${event.remaining}');
          _objectiveCounterController.add(event.remaining);
        });
  }
}
