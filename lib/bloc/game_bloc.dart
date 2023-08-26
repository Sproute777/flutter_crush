import 'dart:async';
import 'dart:convert';
import 'package:flutter_crush/model/level.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart' hide Level;
// import 'package:quiver/iterables.dart';
// import 'package:quiver/quiver.dart';
import 'package:rxdart/rxdart.dart';

class GameBloc {
  static const tag = 'GameBloc';
  final _log = Logger(tag);
  // Max number of tiles per row (and per column)
  static double kMaxTilesPerRowAndColumn = 12.0;
  static double kMaxTilesSize = 28.0;

 
  BehaviorSubject<bool> _readyToDisplayTilesController =
      BehaviorSubject<bool>();
  Function get setReadyToDisplayTiles =>
      _readyToDisplayTilesController.sink.add;
  Stream<bool> get outReadyToDisplayTiles =>
      _readyToDisplayTilesController.stream;

  final levels = <Level>[];

  int _selectedLevel = 0;
  int get selectedLevel => _selectedLevel;

  
  GameBloc() {
    // Load all levels definitions
    unawaited(_loadLevels());
  }

  
  _loadLevels() async {
    try {
      String jsonContent = await rootBundle.loadString("assets/levels.json");
      final list = json.decode(jsonContent) as Map<String, dynamic>;
      print(list.toString());
      (list["levels"] as List).forEach((levelItem) {
        print(levelItem.toString());
        try {
          final l = Level.fromJson(levelItem);
          levels.add(l);
        } catch (e,stack) {
         _log.severe('crash during parse fromJson',e,stack);
        }
      });
    } catch (e, stack) {
      _log.severe('crash during loading assets',e,stack);
    }
  }

  
}
