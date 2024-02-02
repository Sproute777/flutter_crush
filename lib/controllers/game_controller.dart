import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:rxdart/rxdart.dart';

import '../helpers/array_2d.dart';
import '../model/chain.dart';
import '../model/combo.dart';
import '../model/level.dart';
import '../model/objective.dart';
import '../model/objective_event.dart';
import '../model/row_col.dart';
import '../model/swap.dart';
import '../model/swap_move.dart';
import '../model/tile.dart';

class GameController {
  static const tag = 'GameController';
  final _log = Logger(tag);
  Array2d<TileOld>? _grid;
  Array2d<TileOld>? get grid => _grid;
  late math.Random _rnd;

  final levelNtf = ValueNotifier<Level?>(null);
  //
  // List of all possible Swaps
  //
  late HashMap<int, Swap> _swaps;
  List<Swap> get swaps => _swaps.values.toList();

  //
  // Helper to identify the variations of a move
  // (used to determine the possible swaps)
  //
  static const List<SwapMove> _moves = <SwapMove>[
    SwapMove(row: 0, col: -1),
    SwapMove(row: 0, col: 1),
    SwapMove(row: -1, col: 0),
    SwapMove(row: 1, col: 0),
  ];

  //
  // Helper to identity the variations of positions
  // depending on an explosion type
  //
  final Map<TileType, List<SwapMove>> _explosions = {
    TileType.flare: <SwapMove>[
      const SwapMove(row: 0, col: -1),
      const SwapMove(row: 0, col: 1),
      const SwapMove(row: -1, col: 0),
      const SwapMove(row: 1, col: 0),
      const SwapMove(row: 0, col: 0),
    ],
    TileType.bomb: <SwapMove>[
      const SwapMove(row: 0, col: -2),
      const SwapMove(row: 0, col: -1),
      const SwapMove(row: 0, col: 1),
      const SwapMove(row: 0, col: 2),
      const SwapMove(row: -1, col: 0),
      const SwapMove(row: -1, col: -1),
      const SwapMove(row: -1, col: 1),
      const SwapMove(row: 1, col: -1),
      const SwapMove(row: 1, col: 0),
      const SwapMove(row: 1, col: 1),
      const SwapMove(row: -2, col: 0),
      const SwapMove(row: 2, col: 0),
      const SwapMove(row: 0, col: 0),
    ],
    TileType.wrapped: <SwapMove>[
      const SwapMove(row: 0, col: -3),
      const SwapMove(row: 0, col: -2),
      const SwapMove(row: 0, col: -1),
      const SwapMove(row: 0, col: 1),
      const SwapMove(row: 0, col: 2),
      const SwapMove(row: 0, col: 3),
      const SwapMove(row: -1, col: -2),
      const SwapMove(row: -1, col: -1),
      const SwapMove(row: -1, col: 0),
      const SwapMove(row: -1, col: 1),
      const SwapMove(row: -1, col: 2),
      const SwapMove(row: 1, col: -2),
      const SwapMove(row: 1, col: -1),
      const SwapMove(row: 1, col: 0),
      const SwapMove(row: 1, col: 1),
      const SwapMove(row: 1, col: 2),
      const SwapMove(row: -2, col: -1),
      const SwapMove(row: -2, col: 0),
      const SwapMove(row: -2, col: 1),
      const SwapMove(row: 2, col: -1),
      const SwapMove(row: 2, col: 0),
      const SwapMove(row: 2, col: 1),
      const SwapMove(row: -3, col: 0),
      const SwapMove(row: 3, col: 0),
      const SwapMove(row: 0, col: 0),
    ],
  };

  //
  // Initialization
  //
  GameController() {
    // Initialize the grid to the dimensions of the Level and fill it with "empty" tiles

    // Initialize the Random generator
    _rnd = math.Random();

    // Initialize the swaps Set
    _swaps = HashMap<int, Swap>();
  }

  ///
  /// Initialize the Tiles in the game
  /// Only the empty cells are to be considered
  ///
  Future<void> shuffle() async {
    TileType? type;
    final clone = _grid!.copyWith() as Array2d<TileOld>;
    bool isFirst = true;
    do {
      if (!isFirst) {
        _grid = clone.copyWith() as Array2d<TileOld>;
      }
      isFirst = false;

      //
      // 1. Fill the empty cells
      //
      for (int row = 0; row < levelNtf.value!.rows; row++) {
        for (int col = 0; col < levelNtf.value!.cols; col++) {
          // Only consider the empty cells
          if (_grid!.array![row][col].type != TileType.empty) {
            // print('shufl continue ${_grid.array![row][col]?.type}');
            continue;
          }
          TileOld? tile;
          switch (levelNtf.value!.grid.array![row][col]) {
            case '1': // Regular cell
            case '2': // Regular cell but frozen

              do {
                type = TileOld.random(_rnd);
              } while ((col > 1 &&
                      _grid!.array![row][col - 1].type == type &&
                      _grid!.array![row][col - 2].type == type) ||
                  (row > 1 &&
                      _grid!.array![row - 1][col].type == type &&
                      _grid!.array![row - 2][col].type == type));
              tile = TileOld(
                  row: row,
                  col: col,
                  type: type,
                  levelNtf: levelNtf,
                  depth:
                      (levelNtf.value!.grid.array![row][col] == '2') ? 1 : 0);

            case 'X':
              // No cell
              tile = TileOld(
                  row: row,
                  col: col,
                  type: TileType.forbidden,
                  levelNtf: levelNtf,
                  depth: 1);

            case 'W':
              // A wall
              tile = TileOld(
                  row: row,
                  col: col,
                  type: TileType.wall,
                  levelNtf: levelNtf,
                  depth: 1);
          }

          // Assign the tile
          if (tile != null) {
            _grid!.array![row][col] = tile;
          }
        }
      }

      //
      // 2. Identify the possible swaps
      //
      identifySwaps();
    } while (_swaps.isEmpty);

    //
    // Once everything is set, build the tile Widgets
    //
    for (int row = 0; row < levelNtf.value!.rows; row++) {
      for (int col = 0; col < levelNtf.value!.cols; col++) {
        // Only consider the authorized cells (not forbidden)
        if (_grid!.array?[row][col].type == TileType.forbidden) {
          continue;
        }

        _grid!.array![row][col].build();
      }
    }
  }

  //
  // Identify the possible Swaps
  //
  void identifySwaps() {
    _swaps.clear();

    int index;
    int destRow;
    int destCol;
    final int totalRows = _grid!.height;
    final int totalCols = _grid!.width;
    TileOld? fromTile;
    TileOld? toTile;
    bool isSrcNormalTile;
    bool isSrcBombTile;
    bool isDestNormalTile;
    bool isDestBombTile;

    SwapMove move;

    for (int row = 0; row < totalRows; row++) {
      for (int col = 0; col < totalCols; col++) {
        index = -1;
        fromTile = _grid!.array![row][col];
        isSrcNormalTile = TileOld.isNormal(fromTile.type);
        isSrcBombTile = TileOld.isBomb(fromTile.type);

        if (isSrcNormalTile || isSrcBombTile) {
          do {
            index++;
            move = _moves[index];
// T0D0: check if the move is allowed (barriers)
            destRow = row + move.row;
            destCol = col + move.col;

            if (destRow > -1 &&
                destRow < totalRows &&
                destCol > -1 &&
                destCol < totalCols) {
              toTile = _grid!.array![destRow][destCol];
              // If the destination does not exist, skip
              if (toTile.type == TileType.forbidden) {
                continue;
              }

              // If the source tile is a bomb or if the destination tile is empty, all swaps are possible
              if (isSrcBombTile) {
                _addSwaps(fromTile, toTile);
                continue;
              }

              isDestNormalTile = TileOld.isNormal(toTile.type);
              isDestBombTile = TileOld.isBomb(toTile.type);

              // If the destination tile is a bomb, all swaps are possible
              if (isDestBombTile) {
                // _log.finest('move is  ${move.row} ${move.col}');
                _addSwaps(fromTile, toTile);
                continue;
              }

              // If we want to swap the same type of tile => skip
              if (toTile.type == fromTile.type) {
                continue;
              }

              if (isDestNormalTile || toTile.type == TileType.empty) {
                // Exchange the tiles
                _grid!.array![destRow][destCol] = TileOld(
                    row: row,
                    col: col,
                    type: fromTile.type,
                    levelNtf: levelNtf);
                _grid!.array![row][col] = TileOld(
                    row: destRow,
                    col: destCol,
                    type: toTile.type,
                    levelNtf: levelNtf);

                //
                // check if this change creates a chain
                //
                Chain? chainH = checkHorizontalChain(destRow, destCol);
                if (chainH != null) {
                  _addSwaps(fromTile, toTile);
                }

                Chain? chainV = checkVerticalChain(destRow, destCol);
                if (chainV != null) {
                  _addSwaps(fromTile, toTile);
                }

                chainH = checkHorizontalChain(row, col);
                if (chainH != null) {
                  _addSwaps(toTile, fromTile);
                }

                chainV = checkVerticalChain(row, col);
                if (chainV != null) {
                  _addSwaps(toTile, fromTile);
                }

                // Revert back
                _grid!.array![destRow][destCol] = toTile;
                _grid!.array![row][col] = fromTile;
              }
            }
          } while (index < 3);
        }
      }
    }
  }

  //
  // Since the hashCode varies with the direction of a swap, we need
  // to record both
  //
  void _addSwaps(TileOld fromTile, TileOld toTile) {
    Swap newSwap = Swap(from: fromTile, to: toTile);
    _swaps.putIfAbsent(newSwap.hashCode, () => newSwap);

    newSwap = Swap(from: toTile, to: fromTile);
    _swaps.putIfAbsent(newSwap.hashCode, () => newSwap);
  }

  //
  // Check if there is a vertical chain.
  //
  Chain? checkVerticalChain(int row, int col) {
    final Chain chain = Chain(type: ChainType.vertical);
    final int minRow = math.max(0, row - 5);
    final int maxRow = math.min(row + 5, _grid!.height - 1);
    var index = row;
    final TileType? type = _grid!.array![row][col].type;

    // By default the tested tile is part of the chain
    chain.addTile(_grid!.array![row][col]);

    // Search Down
    index = row - 1;
    while (index >= minRow &&
        _grid!.array![index][col].type == type &&
        _grid!.array![index][col].type != TileType.empty) {
      chain.addTile(_grid!.array![index][col]);
      index--;
    }

    // Search Up
    index = row + 1;
    while (index <= maxRow &&
        _grid!.array![index][col].type == type &&
        _grid!.array![index][col].type != TileType.empty) {
      chain.addTile(_grid!.array?[index][col]);
      index++;
    }

    // If the chain counts at least 3 tiles => return it
    return chain.length > 2 ? chain : null;
  }

  //
  // Check if there is a horizontal chain.
  //
  Chain? checkHorizontalChain(int row, int col) {
    final Chain chain = Chain(type: ChainType.horizontal);
    final int minCol = math.max(0, col - 5);
    final int maxCol = math.min(col + 5, _grid!.width - 1);
    int index = col;
    final TileType? type = _grid!.array![row][col].type;

    // By default the tested tile is part of the chain
    chain.addTile(_grid!.array![row][col]);

    // Search Left
    index = col - 1;
    while (index >= minCol &&
        _grid!.array![row][index].type == type &&
        _grid!.array![row][index].type != TileType.empty) {
      chain.addTile(_grid!.array![row][index]);
      index--;
    }

    // Search Right
    index = col + 1;
    while (index <= maxCol &&
        _grid!.array![row][index].type == type &&
        _grid!.array![row][index].type != TileType.empty) {
      chain.addTile(_grid!.array![row][index]);
      index++;
    }

    // If the chain counts at least 3 tiles => return it
    return chain.length > 2 ? chain : null;
  }

  //
  // Check if the swap between 2 tiles is recognized
  //
  bool swapContains(TileOld source, TileOld destination) {
    final Swap testSwap = Swap(from: source, to: destination);
    return _swaps.keys.contains(testSwap.hashCode);
  }

  //
  // Swap 2 tiles
  //
  void swapTiles(TileOld source, TileOld destination) {
    final sourceRowCol = RowCol(row: source.row, col: source.col);
    final destRowCol = RowCol(row: destination.row, col: destination.col);
    source.swapRowColWith(destination);
    final tft = grid!.array![sourceRowCol.row][sourceRowCol.col];
    grid!.array![sourceRowCol.row][sourceRowCol.col] =
        grid!.array![destRowCol.row][destRowCol.col];
    grid!.array![destRowCol.row][destRowCol.col] = tft;
  }

  //
  // Get combo resulting from a move
  //
  Combo getCombo(int row, int col) {
    final Chain? verticalChain = checkVerticalChain(row, col);
    final Chain? horizontalChain = checkHorizontalChain(row, col);

    return Combo(horizontalChain, verticalChain, row, col);
  }

  //
  // Resolves a combo
  //
  void resolveCombo(Combo combo) {
    // We now need to remove all the Tiles from the grid and change the type if necessary
    _log.finest('resolveCombo');
    for (final tile in combo.tiles) {
      if (tile == null) {
        continue;
      }
      if (tile != combo.commonTile) {
        // Decrement the depth
        if (--grid!.array![tile.row][tile.col].depth < 0) {
          // Check for objectives
          pushTileEvent(grid!.array![tile.row][tile.col].type, 1);

          // If the depth is lower than 0, this means that we can remove the tile
          grid!.array![tile.row][tile.col].type = TileType.empty;
        }
        // We need to rebuild the Widget
        grid!.array![tile.row][tile.col].build();
      } else {
        if (combo.commonTile != null) {
          grid!.array![tile.row][tile.col].row = combo.commonTile!.row;
          grid!.array![tile.row][tile.col].col = combo.commonTile!.col;
        }
        grid!.array![tile.row][tile.col].type = combo.resultingTileType;
        grid!.array![tile.row][tile.col].visible = true;
        grid!.array![tile.row][tile.col].build();

        // We need to notify about the creation of a new tile
        pushTileEvent(combo.resultingTileType, 1);
      }
    }
  }

  //
  // Rebuilds the grid, once all animations are complete
  //
  void refreshGridAfterAnimations(
      Array2d<TileType> tileTypes, Set<RowCol> involvedCells) {
    for (final rowCol in involvedCells) {
      _grid!.array![rowCol.row][rowCol.col].row = rowCol.row;
      _grid!.array![rowCol.row][rowCol.col].col = rowCol.col;
      _grid!.array![rowCol.row][rowCol.col].type =
          tileTypes.array![rowCol.row][rowCol.col];
      _grid!.array![rowCol.row][rowCol.col].visible = true;
      _grid!.array![rowCol.row][rowCol.col].depth = 0;
      _grid!.array![rowCol.row][rowCol.col].build();
    }
  }

  //
  // Proceed with an explosion
  // The spread of the explosion depends on the type of bomb
  //
  void proceedWithExplosion(TileOld tileExplosion, {bool skipThis = false}) {
    // Retrieve the list of row/col variations
    final List<SwapMove>? swaps = _explosions[tileExplosion.type];

    // We will record any explosions that could happen should
    // a bomb make another bomb explode
    final List<TileOld> subExplosions = <TileOld>[];

    // All the tiles in that area will disappear
    swaps?.forEach((SwapMove move) {
      final int row = tileExplosion.row + move.row;
      final int col = tileExplosion.col + move.col;

      // Test if the cell is valid
      if (row > -1 &&
          row < levelNtf.value!.rows &&
          col > -1 &&
          col < levelNtf.value!.cols) {
        // And also if we may explode the tile
        if (levelNtf.value!.grid.array![row][col] == '1') {
          final TileOld tile = _grid!.array![row][col];

          if (TileOld.isBomb(tile.type) && !skipThis) {
            // Another bomb must explode
            subExplosions.add(tile);
          } else {
            // Notify that we removed some tiles
            pushTileEvent(tile.type, 1);

            // Empty the cell
            tile.type = TileType.empty;
            tile.build();
          }
        }
      }
    });

    // Proceed with chained explosions
    for (final tile in subExplosions) {
      proceedWithExplosion(tile, skipThis: true);
    }
  }

// Controller aimed at processing the Objective events
  //
  final PublishSubject<ObjectiveEvent> _objectiveEventsController =
      PublishSubject<ObjectiveEvent>();
  void setObjectiveEvent(ObjectiveEvent event) =>
      _objectiveEventsController.sink.add(event);
  Stream<ObjectiveEvent> get outObjectiveEvents =>
      _objectiveEventsController.stream;

  final PublishSubject<bool> _gameIsOverController = PublishSubject<bool>();
  Stream<bool> get gameIsOver => _gameIsOverController.stream;

  void pushTileEvent(TileType? tileType, int counter) {
    // We first need to decrement the objective by the counter
    Objective? objective;
    try {
      objective =
          levelNtf.value!.objectives.firstWhere((o) => o.type == tileType);
    } catch (_) {}
    if (objective == null) {
      return;
    }

    objective.decrement(counter);
    // _log.finest('objective result ${objective.toString()}');
    // Send a notification
    setObjectiveEvent(
        ObjectiveEvent(type: tileType, remaining: objective.count));

    // Check if the game is won
    bool isWon = true;
    for (final objective in levelNtf.value!.objectives) {
      if ((objective.count) > 0) {
        isWon = false;
      }
    }

    // If the game is won, send a notification
    if (isWon) {
      _gameIsOverController.sink.add(true);
    }
  }

  Future<void> setLevel(Level lvl) async {
    levelNtf.value = lvl;
    _log.info(lvl);
    _grid = Array2d<TileOld>(lvl.rows, lvl.cols,
        defaultValue: TileOld(
            type: TileType.empty, levelNtf: ValueNotifier<Level?>(null)));
    // Fill the Game with Tile and make sure there are possible Swaps
    //
    await shuffle();
    //  .timeout(Duration(seconds: 10));
  }

  final PublishSubject<int> _movesLeftController = PublishSubject<int>();
  Stream<int> get movesLeftCount => _movesLeftController.stream;

  void playMove() {
    levelDecrementMove();
    // Emit the number of moves left (to refresh the moves left panel)
    _movesLeftController.sink.add(levelNtf.value!.movesLeft);

    // There is no move left, so inform that the game is over
    if (levelNtf.value!.movesLeft == 0) {
      _gameIsOverController.sink.add(false);
    }
  }

  void setBoardTop(double value) {
    _log.warning('setBoardTop $value');
    levelNtf.value = levelNtf.value!.copyWith(boardTop: value);
    _log.warning('setBoardTop value ${levelNtf.value}');
  }

  void setBoardLeft(double value) {
    _log.warning('setBoardLeft $value');
    levelNtf.value = levelNtf.value!.copyWith(boardLeft: value);
    _log.warning('setBoardTop value ${levelNtf.value}');
  }

  void setTileWidth(double value) {
    _log.warning('setTileWidth $value');
    levelNtf.value = levelNtf.value!.copyWith(tileWidth: value);
    _log.warning('setBoardTop value ${levelNtf.value}');
  }

  void setTileHeight(double value) {
    _log.warning('setTileHeight $value');
    levelNtf.value = levelNtf.value!.copyWith(tileHeight: value);
    _log.warning('setBoardTop value ${levelNtf.value}');
  }

  void levelDecrementMove() {
    final movesLeft =
        (levelNtf.value!.movesLeft - 1).clamp(0, levelNtf.value!.maxMoves);
    levelNtf.value = levelNtf.value!.copyWith(movesLeft: movesLeft);
  }

  void resetAims() {
    levelNtf.value?.objectives.forEach((element) {
      element.reset();
    });
  }
}
