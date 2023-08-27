import 'package:equatable/equatable.dart';
import 'package:flutter_crush/helpers/array_2d.dart';
import 'package:flutter_crush/model/objective.dart';
import 'package:json_annotation/json_annotation.dart';

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

class Level extends Object {
  final int _index;
  late Array2d grid;
  final int _rows;
  final int _cols;
  List<Objective>? _objectives;
  final int _maxMoves;
  int? _movesLeft;
  Level(this._index, this._rows, this._cols, this._maxMoves);
  //
  // Variables that depend on the physical layout of the device
  //
  double tileWidth = 0.0;
  double tileHeight = 0.0;
  double boardLeft = 0.0;
  double boardTop = 0.0;

  Level.fromSettings(LevelSettings settings)
      : _index = settings.index,
        _rows = settings.rows,
        _cols = settings.cols,
        _maxMoves = settings.moves {
    // Initialize the grid to the dimensions
    grid = Array2d<String>(_rows, _cols, defaultValue: '');
    _movesLeft = _maxMoves;
    // Populate the grid from the definition
    //
    // Trick
    //  As the definition in the JSON file defines the
    //  rows (top-down) and also because we are recording
    //  the grid (bottom-up), we need to reverse the
    //  definition from the JSON file.
    //
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

    print('next objectives');
    // Retrieve the objectives
    _objectives = settings.aimConfig.map((item) {
      return Objective(item);
    }).toList();

    // First-time initialization
    resetObjectives();
  }

  @override
  String toString() {
    return "level: $index \n" + dumpArray2d(grid);
  }

  int get numberOfRows => _rows;
  int get numberOfCols => _cols;
  int get index => _index;
  int get maxMoves => _maxMoves;
  int get movesLeft => _movesLeft!;
  List<Objective> get objectives =>
      List.unmodifiable(_objectives as List<Objective>);

  //
  // Reset the objectives
  //
  void resetObjectives() {
    _objectives?.forEach((Objective objective) => objective.reset());
    _movesLeft = _maxMoves;
  }

  //
  // Decrement the number of moves left
  //
  int decrementMove() {
    _movesLeft = (_movesLeft! - 1).clamp(0, _maxMoves);
    return _movesLeft!;
  }
}
