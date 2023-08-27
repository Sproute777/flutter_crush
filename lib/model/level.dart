// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_crush/helpers/array_2d.dart';
import 'package:flutter_crush/model/objective.dart';

part 'level.g.dart';

@JsonSerializable(explicitToJson: false)
class LevelSettings extends Equatable {
  @JsonKey(name: 'level')
  final int index;
  final int rows;
  final int cols;
  final int moves;
  @JsonKey(name: 'grid')
  final List<String> gridConfig;
  @JsonKey(name: 'objective')
  final List<String> aimConfig;

  LevelSettings({
    required this.index,
    required this.rows,
    required this.cols,
    required this.moves,
    required this.gridConfig,
    required this.aimConfig,
  });

  @override
  List<Object?> get props => [index, rows, cols, moves, gridConfig, aimConfig];

  factory LevelSettings.fromJson(Map<String, dynamic> json) {
    return _$LevelSettingsFromJson(json);
  }
}

class Level extends Equatable {
  Level(
      {required this.index,
      required this.rows,
      required this.cols,
      required this.maxMoves,
      this.tileWidth = 0.0,
      this.tileHeight = 0.0,
      this.boardLeft = 0.0,
      this.boardTop = 0.0,
      required this.grid,
      required this.objectives,
      required this.movesLeft,});
  final int index;
  final Array2d grid;
  final int rows;
  final int cols;
  final List<Objective> objectives;
  final int maxMoves;
  final int movesLeft;
  final double tileWidth;
  final double tileHeight;
  final double boardLeft;
  final double boardTop;

  // Variables that depend on the physical layout of the device
  //
factory  Level.fromSettings(LevelSettings settings) {
    final grid = Array2d(settings.rows, settings.cols, defaultValue: '');
    final objectives = settings.aimConfig.map((item) {
      return Objective(item);
    }).toList();
    final row = List.of(settings.gridConfig.reversed);
    for (var rowIndex = 0; rowIndex < row.length; rowIndex++) {
      final listCell = row[rowIndex].split(',');
      for (var cellIndex = 0; cellIndex < listCell.length; cellIndex++) {
        final cell = listCell[cellIndex];
        try {
          grid.array![rowIndex][cellIndex] = cell;
        } catch (e) {
          print(e);
          rethrow;
        }
      }
    }
    objectives.forEach((Objective objective) => objective.reset());

    return Level(
      index: settings.index,
      rows: settings.rows,
      cols: settings.cols,
      maxMoves: settings.moves,
      movesLeft: settings.moves,
      grid: grid,
      objectives: objectives,
    );
  }
  //     : index = settings.index,
  //       rows = settings.rows,
  //       cols = settings.cols,
  //       maxMoves = settings.moves {
  //   // Initialize the grid to the dimensions
  //   grid = Array2d<String>(rows, cols, defaultValue: '');
  //   movesLeft = maxMoves;
  //   // Populate the grid from the definition
  //   //
  //   // Trick
  //   //  As the definition in the JSON file defines the
  //   //  rows (top-down) and also because we are recording
  //   //  the grid (bottom-up), we need to reverse the
  //   //  definition from the JSON file.
  //   //
  //   final row = List.of(settings.gridConfig.reversed);
  //   for (var rowIndex = 0; rowIndex < row.length; rowIndex++) {
  //     final listCell = row[rowIndex].split(',');
  //     for (var cellIndex = 0; cellIndex < listCell.length; cellIndex++) {
  //       final cell = listCell[cellIndex];
  //       try {
  //         grid.array![rowIndex][cellIndex] = cell;
  //       } catch (e) {
  //         print(e);
  //         rethrow;
  //       }
  //     }
  //   }

  //   print('next objectives');
  //   // Retrieve the objectives
  //   _objectives = settings.aimConfig.map((item) {
  //     return Objective(item);
  //   }).toList();

  //   // First-time initialization
  //   resetObjectives();
  // }

  // @override
  // String toString() {
  //   return "level: $index \n" + dumpArray2d(grid);
  // }

  // int get numberOfRows => _rows;
  // int get numberOfCols => _cols;
  // int get index => _index;
  // int get maxMoves => _maxMoves;
  // int get movesLeft => _movesLeft!;
  // List<Objective> get objectives =>
  //     List.unmodifiable(_objectives as List<Objective>);

  //
  // Reset the objectives
  //
  // void resetObjectives() {
  //   objectives?.forEach((Objective objective) => objective.reset());
  //   movesLeft = maxMoves;
  // }

  //
  // Decrement the number of moves left
  //
  // int decrementMove() {
  //   _movesLeft = (_movesLeft! - 1).clamp(0, _maxMoves);
  //   return _movesLeft!;
  // }

  // @override
  // List<Object?> get props => [
  //       index,
  //       cols,
  //       maxMoves,
  //       rows,
  //       objectives,
  //       movesLeft,
  //     ];

  Level copyWith({
    int? index,
    Array2d? grid,
    int? rows,
    int? cols,
    List<Objective>? objectives,
    int? maxMoves,
    int? movesLeft,
    double? tileWidth,
    double? tileHeight,
    double? boardLeft,
    double? boardTop,
  }) {
    return Level(
    index:  index ?? this.index,
     grid: grid ?? this.grid,
     rows: rows ?? this.rows,
     cols: cols ?? this.cols,
     objectives: objectives ?? this.objectives,
     maxMoves: maxMoves ?? this.maxMoves,
     movesLeft: movesLeft ?? this.movesLeft,
     tileWidth: tileWidth ?? this.tileWidth,
     tileHeight: tileHeight ?? this.tileHeight,
     boardLeft: boardLeft ?? this.boardLeft,
     boardTop: boardTop ?? this.boardTop,
    );
  }
  

  @override
  List<Object> get props {
    return [
      index,
      grid,
      rows,
      cols,
      objectives,
      maxMoves,
      movesLeft,
      tileWidth,
      tileHeight,
      boardLeft,
      boardTop,
    ];
  }
}
