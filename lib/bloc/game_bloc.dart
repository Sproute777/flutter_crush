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

  //
  // Controller that emits a boolean value to trigger the display of the tiles
  // at game load is ready.  This is done as soon as this BLoC receives the
  // dimensions/position of the board as well as the dimensions of a tile
  //
  BehaviorSubject<bool> _readyToDisplayTilesController =
      BehaviorSubject<bool>();
  Function get setReadyToDisplayTiles =>
      _readyToDisplayTilesController.sink.add;
  Stream<bool> get outReadyToDisplayTiles =>
      _readyToDisplayTilesController.stream;

  //
  // Controller aimed at processing the Objective events
  //
  // PublishSubject<ObjectiveEvent> _objectiveEventsController =
  //     PublishSubject<ObjectiveEvent>();
  // void  setObjectiveEvent(ObjectiveEvent event) => _objectiveEventsController.sink.add(event);
  // Stream<ObjectiveEvent> get outObjectiveEvents =>
  //     _objectiveEventsController.stream;

  //
  // Controller that emits a boolean value to notify that a game is over
  // the boolean value indicates whether the game is won (=true) or lost (=false)
  //
  // PublishSubject<bool> _gameIsOverController = PublishSubject<bool>();
  // Stream<bool> get gameIsOver => _gameIsOverController.stream;

  //
  // Controller that emits the number of moves left for the game
  //
  // PublishSubject<int> _movesLeftController = PublishSubject<int>();
  // Stream<int> get movesLeftCount => _movesLeftController.stream;

  //
  // List of all level definitions
  //
  final levels = <Level>[];

  int _selectedLevel = 0;
  int get selectedLevel => _selectedLevel;

  //
  // The Controller for the Game being played
  //
  // late GameController _gameController;
  // GameController get gameController => _gameController;

  //
  // Constructor
  //
  GameBloc() {
    // Load all levels definitions
    unawaited(_loadLevels());
  }

  //
  // The user wants to select a level.
  // We validate the level number and emit the requested Level
  //
  // We use the [async] keyword to allow the caller to use a Future
  //
  //  e.g.  bloc.setLevel(1).then(() => )
  //
  // Future<Level?> setLevel(int levelIndex) async {
  //   _log.fine('setLevel');
  //   _selectedLevel = (levelIndex - 1).clamp(0, levels.length);

  //   _log.fine('get _gameController');
  //   //
  //   // Initialize the Game
  //   //
  //   _gameController = GameController(level: levels[_selectedLevel]);
  //   _log.fine('_gameController ${_gameController.level}');

  //   //
  //   // Fill the Game with Tile and make sure there are possible Swaps
  //   //
  //   _log.fine('shufl _gameController');
  //  await _gameController.shuffle();
  // //  .timeout(Duration(seconds: 10));

  //     return levels[_selectedLevel];
  // }

  //
  // Load the levels definitions from assets
  //
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

  //
  // A certain number of tiles have been removed (or created)
  // We need to notify anyone who might be interested in
  // knowing it so that actions can be taken
  //
  // void pushTileEvent(TileType? tileType, int counter) {
  //   // We first need to decrement the objective by the counter
  //   print('ssetLevel');
  //   Objective? objective;
  //   try {
  //     objective =
  //         gameController.level.objectives.firstWhere((o) => o.type == tileType);
  //   } catch (_) {}
  //   if (objective == null) {
  //     return;
  //   }

  //   objective.decrement(counter);

  //   // Send a notification
  //   setObjectiveEvent(
  //       ObjectiveEvent(type: tileType, remaining: objective.count));

  //   // Check if the game is won
  //   bool isWon = true;
  //   gameController.level.objectives.forEach((Objective? objective) {
  //     if ((objective?.count ?? 0) > 0) {
  //       isWon = false;
  //     }
  //   });

  //   // If the game is won, send a notification
  //   if (isWon) {
  //     _gameIsOverController.sink.add(true);
  //   }
  // }

  //
  // A move has been played, let's decrement the number of moves
  // left and check if the game is over
  //
  // void playMove() {
  //   print('playMode');
  //   int movesLeft = gameController.level.decrementMove();

  //   // Emit the number of moves left (to refresh the moves left panel)
  //   _movesLeftController.sink.add(movesLeft);

  //   // There is no move left, so inform that the game is over
  //   if (movesLeft == 0) {
  //     _gameIsOverController.sink.add(false);
  //   }
  // }

  //
  // When a game starts, we need to reset everything
  //
  // void reset() {
  //   gameController.level.resetObjectives();
  // }

  // @override
  // void dispose() {
  //   _readyToDisplayTilesController.close();
  //   _objectiveEventsController.close();
  //   _gameIsOverController.close();
  //   _movesLeftController.close();
  // }
}
