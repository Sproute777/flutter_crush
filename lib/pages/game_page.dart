import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' hide Level;

import '../animations/animation_chain.dart';
import '../animations/animation_combo_collapse.dart';
import '../animations/animation_combo_three.dart';
import '../animations/animation_swap_tiles.dart';
import '../bloc/ready_bloc.dart';
import '../controllers/game_controller.dart';
import '../game_widgets/board.dart';
import '../game_widgets/game_moves_left_panel.dart';
import '../game_widgets/game_over_splash.dart';
import '../game_widgets/game_splash.dart';
import '../game_widgets/objective_panel.dart';
import '../game_widgets/shadowed_text.dart';
import '../helpers/animations_resolver.dart';
import '../helpers/array_2d.dart';
import '../model/animation_sequence.dart';
import '../model/combo.dart';
import '../model/level.dart';
import '../model/row_col.dart';
import '../model/tile.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.level});
  final Level level;
  static Route<dynamic> route(Level level) {
    return MaterialPageRoute(
        builder: (BuildContext context) => GamePage(level: level));
  }

  @override
  Widget build(BuildContext context) {
    return GameView(level: level);
  }
}

class GameView extends StatefulWidget {
  final Level level;
  const GameView({
    super.key,
    required this.level,
  });

  @override
  GameViewState createState() => GameViewState();
}

class GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  // late final AnimationController _controller;
  OverlayEntry? _gameSplash;
  ReadyBloc? readyBloc;
  GameController? gameController;
  bool _allowGesture = true;
  StreamSubscription? _gameOverSubscription;
  late bool _gameOverReceived;

  TileOld? gestureFromTile;
  RowCol? gestureFromRowCol;
  Offset? gestureOffsetStart;
  bool gestureStarted = false;
  static const double _MIN_GESTURE_DELTA = 2.0;
  OverlayEntry? _overlayEntryFromTile;
  OverlayEntry? _overlayEntryAnimateSwapTiles;

  @override
  void initState() {
    super.initState();
    _gameOverReceived = false;
    WidgetsBinding.instance.addPostFrameCallback(_showGameStartSplash);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Now that the context is available, retrieve the gameBloc
    readyBloc = RepositoryProvider.of<ReadyBloc>(context);
    gameController = RepositoryProvider.of<GameController>(context);
    gameController!.setLevel(widget.level);
    // Reset the objectives
    gameController!.resetAims();

    // Listen to "game over" notification
    _gameOverSubscription = gameController!.gameIsOver.listen(_onGameOver);
  }

  @override
  void dispose() {
    _gameOverSubscription?.cancel();
    _gameOverSubscription = null;
    _overlayEntryAnimateSwapTiles?.remove();
    _overlayEntryFromTile?.remove();
    _gameSplash?.remove();
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    gameController = RepositoryProvider.of<GameController>(context);
    return ValueListenableBuilder(
        valueListenable: gameController!.levelNtf,
        builder: (context, level, _) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/background/background2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: GestureDetector(
                onPanDown: _onPanDown,
                onPanStart: _onPanStart,
                onPanEnd: _onPanEnd,
                onPanUpdate: _onPanUpdate,
                onTap: _onTap,
                onTapUp: _onPanEnd,
                child: Stack(
                  children: <Widget>[
                    _buildMovesLeftPanel(orientation),
                    _buildObjectivePanel(orientation),
                    _buildBoard(gameController!.levelNtf),
                    _buildTiles(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  

  //
  // Builds the score panel
  //
  Widget _buildMovesLeftPanel(Orientation orientation) {
    final alignment = orientation == Orientation.portrait
        ? Alignment.topLeft
        : Alignment.topLeft;

    return Align(
      alignment: alignment,
      child: const GameMovesLeftPanel(),
    );
  }

  //
  // Builds the objective panel
  //
  Widget _buildObjectivePanel(Orientation orientation) {
    final alignment = orientation == Orientation.portrait
        ? Alignment.topRight
        : Alignment.bottomLeft;

    return Align(
      alignment: alignment,
      child: const ObjectivePanel(),
    );
  }

  //
  // Builds the game board
  //
  Widget _buildBoard(ValueNotifier<Level?> levelNtf) {
    if (levelNtf.value == null) {
      return const SizedBox();
    }
    return Align(
      // alignment: Alignment.center,
      child: Board(
        rows: levelNtf.value!.rows,
        cols: levelNtf.value!.cols,
        levelNtf: levelNtf,
      ),
    );
  }

  //
  // Builds the tiles
  //
  Widget _buildTiles() {
    return StreamBuilder<bool>(
      stream: readyBloc!.outReadyToDisplayTiles,
      // initialData: null,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          final List<Widget> tiles = <Widget>[];
          final Array2d<TileOld?> grid = gameController!.grid!;

          for (int row = 0; row < gameController!.levelNtf.value!.rows; row++) {
            for (int col = 0;
                col < gameController!.levelNtf.value!.cols;
                col++) {
              final tile = grid.array![row][col];
              if (tile != null &&
                  tile.type != TileType.empty &&
                  tile.type != TileType.forbidden &&
                  tile.visible) {
                //
                // Make sure the widget is correctly positioned
                //
                tile.setPosition();
                tiles.add(Positioned(
                  left: tile.location.x,
                  top: tile.location.y,
                  child: tile.widget,
                ));
              }
            }
          }

          return Stack(
            children: tiles,
          );
          // return Flow(delegate: TileFlowDelegate(),);
        }
        // If nothing is ready, simply return an empty container
        return const SizedBox();
      },
    );
  }

  //
  // Gesture
  //

  RowCol _rowColFromGlobalPosition(Offset globalPosition) {
    final double top =
        globalPosition.dy - gameController!.levelNtf.value!.boardTop;
    final double left =
        globalPosition.dx - gameController!.levelNtf.value!.boardLeft;
    Logger.root.info(
        '(_rowColFromGlobalPosition) . $top $left ${gameController!.levelNtf.value!.tileWidth} ${gameController!.levelNtf.value!.tileHeight}');
    return RowCol(
      col: (left / gameController!.levelNtf.value!.tileWidth).floor(),
      row: gameController!.levelNtf.value!.rows -
          (top / gameController!.levelNtf.value!.tileHeight).floor() -
          1,
    );
  }

  //
  // The pointer touches the screen
  //
  void _onPanDown(DragDownDetails details) {
    if (!_allowGesture) {
      return;
    }

    // Determine the [row,col] from touch position
    final RowCol rowCol = _rowColFromGlobalPosition(details.globalPosition);

    // Ignore if we touched outside the grid
    if (rowCol.row < 0 ||
        rowCol.row >= gameController!.levelNtf.value!.rows ||
        rowCol.col < 0 ||
        rowCol.col >= gameController!.levelNtf.value!.cols) {
      return;
    }

    // Check if the [row,col] corresponds to a possible swap
    final TileOld selectedTile =
        gameController!.grid!.array![rowCol.row][rowCol.col];
    bool canBePlayed = false;

    // Reset
    gestureFromTile = null;
    gestureStarted = false;
    gestureOffsetStart = null;
    gestureFromRowCol = null;

    canBePlayed = selectedTile.canMove;

    if (canBePlayed) {
      gestureFromTile = selectedTile;
      gestureFromRowCol = rowCol;

      //
      // Let's position the tile on the Overlay and inflate it a bit to make it more visible
      //
      _overlayEntryFromTile = OverlayEntry(
          // opaque: false,
          builder: (BuildContext context) {
        return Positioned(
          left: gestureFromTile!.location.x,
          top: gestureFromTile!.location.y,
          child: Transform.scale(
            scale: 1.1,
            child: gestureFromTile!.widget,
          ),
        );
      });
      Overlay.of(context).insert(_overlayEntryFromTile!);
    }
  }

  //
  // The pointer starts to move
  //
  void _onPanStart(DragStartDetails details) {
    if (!_allowGesture) {
      return;
    }
    if (gestureFromTile != null) {
      gestureStarted = true;
      gestureOffsetStart = details.globalPosition;
    }
  }

  //
  // The user releases the pointer from the screen
  //
  void _onPanEnd(_) {
    if (!_allowGesture) {
      return;
    }

    gestureStarted = false;
    gestureOffsetStart = null;
    _overlayEntryFromTile?.remove();
    _overlayEntryFromTile = null;
  }

  //
  // The pointer has been moved since its last "start"
  //
  void _onPanUpdate(DragUpdateDetails details) {
    if (!_allowGesture) {
      return;
    }

    if (gestureStarted) {
      // Try to determine the move type (up, down, left, right)
      final Offset delta = details.globalPosition - gestureOffsetStart!;
      int deltaRow = 0;
      int deltaCol = 0;
      bool test = false;
      if (delta.dx.abs() > delta.dy.abs() &&
          delta.dx.abs() > _MIN_GESTURE_DELTA) {
        // horizontal move
        deltaCol = delta.dx.floor().sign;
        test = true;
      } else if (delta.dy.abs() > _MIN_GESTURE_DELTA) {
        // vertical move
        deltaRow = -delta.dy.floor().sign;
        test = true;
      }

      if (test) {
        final RowCol rowCol = RowCol(
            row: gestureFromRowCol!.row + deltaRow,
            col: gestureFromRowCol!.col + deltaCol);
        if (rowCol.col < 0 ||
            rowCol.col == gameController!.levelNtf.value!.cols ||
            rowCol.row < 0 ||
            rowCol.row == gameController!.levelNtf.value!.rows) {
          // Not possible, outside the boundaries
        } else {
          final TileOld destTile =
              gameController!.grid!.array![rowCol.row][rowCol.col];
          bool canBePlayed = false;

          //T0D0:  Condition no longer necessary
          canBePlayed = destTile.canMove || destTile.type == TileType.empty;

          if (canBePlayed) {
            // We need to test the swap
            final bool swapAllowed =
                gameController!.swapContains(gestureFromTile!, destTile);

            // Do not allow the gesture recognition during the animation
            _allowGesture = false;

            // 1. Remove the expanded tile
            _overlayEntryFromTile?.remove();
            _overlayEntryFromTile = null;

            // 2. Generate the up/down tiles
            final TileOld upTile = gestureFromTile!.cloneForAnimation();
            final TileOld downTile = destTile.cloneForAnimation();

            // 3. Remove both tiles from the game grid
            gameController!.grid!.array![rowCol.row][rowCol.col].visible =
                false;

            gameController!
                .grid!
                .array![gestureFromRowCol!.row][gestureFromRowCol!.col]
                .visible = false;

            setState(() {});

            // 4. Animate both tiles
            _overlayEntryAnimateSwapTiles = OverlayEntry(
                // opaque: false,
                builder: (BuildContext context) {
              return AnimationSwapTiles(
                upTile: upTile,
                downTile: downTile,
                swapAllowed: swapAllowed,
                onComplete: () async {
                  // 5. Put back the tiles in the game grid
                  gameController!.grid!.array![rowCol.row][rowCol.col].visible =
                      true;

                  gameController!
                      .grid!
                      .array![gestureFromRowCol!.row][gestureFromRowCol!.col]
                      .visible = true;

                  // 6. Remove the overlay Entry
                  _overlayEntryAnimateSwapTiles?.remove();
                  _overlayEntryAnimateSwapTiles = null;

                  if (swapAllowed) {
                    // Remember if the tile we move is a bomb
                    final bool isSourceTileABomb =
                        TileOld.isBomb(gestureFromTile!.type);

                    // Swap the 2 tiles
                    gameController!.swapTiles(gestureFromTile!, destTile);

                    // Get the tiles that need to be removed, following the swap
                    // We need to get the tiles from all possible combos
                    final Combo comboOne = gameController!
                        .getCombo(gestureFromTile!.row, gestureFromTile!.col);
                    final Combo comboTwo =
                        gameController!.getCombo(destTile.row, destTile.col);

                    // Wait for both animations to complete
                    await Future.wait(
                        [_animateCombo(comboOne), _animateCombo(comboTwo)]);

                    // Resolve the combos
                    gameController!.resolveCombo(comboOne);
                    gameController!.resolveCombo(comboTwo);

                    // If the tile we moved is a bomb, we need to process the explosion
                    if (isSourceTileABomb) {
                      gameController!.proceedWithExplosion(
                        TileOld(
                            row: destTile.row,
                            col: destTile.row,
                            levelNtf: gameController!.levelNtf,
                            type: gestureFromTile!.type),
                      );
                    }

                    // Proceed with the falling tiles
                    await _playAllAnimations();

                    // Once this is all done, we need to recalculate all the possible swaps
                    gameController!.identifySwaps();

                    // Record the fact that we have played a move
                    gameController!.playMove();
                  }

                  // 7. Reset
                  _allowGesture = true;
                  _onPanEnd(null);
                  setState(() {});
                },
              );
            });
            if (_overlayEntryAnimateSwapTiles != null) {
              Overlay.of(context).insert(_overlayEntryAnimateSwapTiles!);
            }
          }
        }
      }
    }
  }

  //
  // The user tap on a tile, is this a bomb ?
  // If yes make it explode
  //
  void _onTap() {
    if (!_allowGesture) {
      return;
    }
    if (gestureFromTile != null && TileOld.isBomb(gestureFromTile!.type)) {
      // Prevent the user from playing during the animation
      _allowGesture = false;

      // Play explosion
      // Audio.playAsset(AudioType.bomb);

      // Proceed with explosion
      gameController!.proceedWithExplosion(gestureFromTile!);

      // Rebuild the board and proceed with animations
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Proceed with the falling tiles
        await _playAllAnimations();

        // Once this is all done, we need to recalculate all the possible swaps
        gameController!.identifySwaps();

        // The user may now play
        _allowGesture = true;

        // Record the fact that we have played a move
        gameController!.playMove();
      });
    }
  }

  //
  // Show/hide the tiles related to a Combo.
  // This is used just before starting an animation
  //
  void _showComboTilesForAnimation(Combo combo, bool visible) {
    for (final tile in combo.tiles) {
      tile?.visible = visible;
    }
    setState(() {});
  }

  //
  // Launch an Animation which returns a Future when completed
  //
  Future<dynamic> _animateCombo(Combo combo) async {
    final completer = Completer();
    OverlayEntry? overlayEntry;

    switch (combo.type) {
      case ComboType.three:
        // Hide the tiles before starting the animation
        _showComboTilesForAnimation(combo, false);

        // Launch the animation for a chain of 3 tiles
        overlayEntry = OverlayEntry(
          // opaque: false,
          builder: (BuildContext context) {
            return AnimationComboThree(
              combo: combo,
              onComplete: () {
                overlayEntry?.remove();
                overlayEntry = null;
                completer.complete(null);
              },
            );
          },
        );

        // Play sound
        // await Audio.playAsset(AudioType.move_down);

        Overlay.of(context).insert(overlayEntry!);

      case ComboType.none:
      case ComboType.one:
      case ComboType.two:
        // These type of combos are not possible, therefore directly return
        completer.complete(null);

      default:
        // Hide the tiles before starting the animation
        _showComboTilesForAnimation(combo, false);

        // We need to create the resulting tile
        TileOld? resultingTile = TileOld(
          col: combo.commonTile!.col,
          row: combo.commonTile!.row,
          type: combo.resultingTileType,
          levelNtf: gameController!.levelNtf,
          // depth: 0,
        );
        resultingTile.build();

        // Launch the animation for a chain more than 3 tiles
        overlayEntry = OverlayEntry(
          // opaque: false,
          builder: (BuildContext context) {
            return AnimationComboCollapse(
              combo: combo,
              resultingTile: resultingTile!,
              onComplete: () {
                resultingTile = null;
                overlayEntry?.remove();
                overlayEntry = null;

                completer.complete(null);
              },
            );
          },
        );

        // Play sound
        // await Audio.playAsset(AudioType.swap);

        Overlay.of(context).insert(overlayEntry!);
        break;
    }
    return completer.future;
  }

  //
  // Routine that launches all animations, resulting from a combo
  //
  Future<dynamic> _playAllAnimations() async {
    final completer = Completer();

    //
    // Determine all animations (and sequence of animations) that
    // need to be played as a consequence of a combo
    //
    final AnimationsResolver animationResolver = AnimationsResolver(
        gameController: gameController!, levelNtf: gameController!.levelNtf);
    animationResolver.resolve();

    // Determine the list of cells that are involved in the animation(s)
    // and make them invisible
    if (animationResolver.involvedCells.isEmpty) {
      // At first glance, there is no animations... so directly return
      completer.complete(null);
    }

    // Obtain the animation sequences
    final List<AnimationSequence> sequences =
        animationResolver.getAnimationsSequences();
    int pendingSequences = sequences.length;

    // Make all involved cells invisible
    for (final rowCol in animationResolver.involvedCells) {
      gameController!.grid!.array![rowCol.row][rowCol.col].visible = false;
    }

    // Make a refresh of the board and the end of which we will play the animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      // As the board is now refreshed, it is time to start playing
      // all the animations
      //
      final List<OverlayEntry> overlayEntries = <OverlayEntry>[];

      for (final animationSequence in sequences) {
        //
        // Prepare all the animations at once.
        // This is important to avoid having multiple rebuild
        // when we are going to put them all on the Overlay
        //
        overlayEntries.add(
          OverlayEntry(
            // opaque: false,
            builder: (BuildContext context) {
              return AnimationChain(
                levelNtf: gameController!.levelNtf,
                animationSequence: animationSequence,
                onComplete: () {
                  // Decrement the number of pending animations
                  pendingSequences--;

                  //
                  // When all have finished, we need to "rebuild" the board,
                  // refresh the screen and yied the hand back
                  //
                  if (pendingSequences == 0) {
                    // Remove all OverlayEntries
                    for (final entry in overlayEntries) {
                      entry.remove();
                    }

                    gameController!.refreshGridAfterAnimations(
                        animationResolver.resultingGridInTermsOfTileTypes,
                        animationResolver.involvedCells);

                    // We now need to proceed with a final rebuild and yield the hand
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Finally, yield the hand
                      completer.complete(null);
                    });

                    setState(() {});
                  }
                },
              );
            },
          ),
        );
      }
      Overlay.of(context).insertAll(overlayEntries);
    });

    setState(() {});

    return completer.future;
  }

  //
  // The game is over
  //
  // We need to show the adequate splash (win/lost)
  //
  Future<void> _onGameOver(bool success) async {
    // Prevent from bubbling
    if (_gameOverReceived) {
      return;
    }
    _gameOverReceived = true;

    // Since some animations could still be ongoing, let's wait a bit
    // before showing the user that the game is won
    await Future.delayed(const Duration(seconds: 1));

    // No gesture detection during the splash
    _allowGesture = false;

    // Show the splash
    _gameSplash = OverlayEntry(
        // opaque: false,
        builder: (BuildContext context) {
      return GameOverSplash(
        success: success,
        level: gameController!.levelNtf.value!,
        onComplete: () {
          _gameSplash?.remove();
          _gameSplash = null;

          // as the game is over, let's leave the game
          Navigator.of(context).pop();
        },
      );
    });
    if (context.mounted) {
      Overlay.of(context).insert(_gameSplash!);
    }
  }

  //
  // SplashScreen to be displayed when the game starts
  // to show the user the objectives
  //
  void _showGameStartSplash(_) {
    // No gesture detection during the splash
    _allowGesture = false;

    // Show the splash
    _gameSplash = OverlayEntry(
        // opaque: false,
        builder: (BuildContext context) {
          return GameSplash(
            levelNtf: gameController!.levelNtf,
            onComplete: () {
              _gameSplash?.remove();
              _gameSplash = null;

              // allow gesture detection
              _allowGesture = true;
            },
          );
        });

    Overlay.of(context).insert(_gameSplash!);
  }
}
