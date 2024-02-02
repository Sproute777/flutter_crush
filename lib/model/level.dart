import 'package:freezed_annotation/freezed_annotation.dart';

import '../helpers/array_2d.dart';
import 'ids.dart';
import 'level_settings.dart';
import 'objective.dart';

part 'level.freezed.dart';

@Freezed(
  copyWith: true,
)
class Level with _$Level {
  const Level._();
  const factory Level({
    required LevelId id,
    required int rows,
    required int cols,
    required int maxMoves,
    required double tileWidth,
    required double tileHeight,
    required double boardLeft,
    required double boardTop,
    required Array2d grid,
    required List<Objective> objectives,
    required int movesLeft,
  }) = LevelValue;

  factory Level.fromSettings(LevelSettings settings) {
    final grid = Array2d(settings.rows, settings.cols, defaultValue: '');
    final objectives = settings.aimConfig.map((item) {
      return Objective(item);
    }).toList();
    final row = List.of(settings.gridConfig.reversed);
    for (var rowIndex = 0; rowIndex < row.length; rowIndex++) {
      final listCell = row[rowIndex].split(',');
      for (var cellIndex = 0; cellIndex < listCell.length; cellIndex++) {
        final cell = listCell[cellIndex];
          grid.array![rowIndex][cellIndex] = cell;
      }
    }
    for (final objective in objectives) {
      objective.reset();
    }

    return Level(
      id: settings.id,
      rows: settings.rows,
      cols: settings.cols,
      maxMoves: settings.moves,
      movesLeft: settings.moves,
      grid: grid,
      objectives: objectives,
      tileWidth: 0.0,
      tileHeight: 0.0,
      boardLeft: 0.0,
      boardTop: 0.0,
    );
  }
}
