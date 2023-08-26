import 'dart:collection';

import 'package:flutter_crush/helpers/array_2d.dart';
import 'package:flutter_crush/model/objective.dart';
import 'package:quiver/iterables.dart';

///
/// Level
///
/// Definition of a level in terms of:
///  - grid template
///  - maximum number of moves
///  - number of columns
///  - number of rows
///  - list of objectives
///
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

  Level.fromJson(Map<String, dynamic> json)
      : _index = json["level"] as int,
        _rows = json["rows"] as int,
        _cols = json["cols"] as int,
        _maxMoves = json["moves"] as int {
    print('create aray');
    // Initialize the grid to the dimensions
    try {
      print('grid start');
      print('rows $_rows');
      print('columns $_cols');
      grid = Array2d<String>(_rows, _cols,defaultValue: '');
    } catch (e) {
      print(e);
      print('grid failed');
    }
    // Populate the grid from the definition
    //
    // Trick
    //  As the definition in the JSON file defines the
    //  rows (top-down) and also because we are recording
    //  the grid (bottom-up), we need to reverse the
    //  definition from the JSON file.
    //
    print('next');
    print('grid is ${json['grid'].runtimeType}');
    final row = List.of((json['grid'] as List).reversed);
    for (var rowIndex = 0; rowIndex < row.length; rowIndex++) {
      print('grid row is ${row.runtimeType} ${row.toString()}');
      final listCell = (row[rowIndex] as String).split(',');
      for (var cellIndex = 0; cellIndex < listCell.length; cellIndex++) {
        final cell = listCell[cellIndex];
        print('grid value ${cell.toString()}');
        try{
          print('grid toStr ${grid.array!.length} ${grid.toString()}');
        print('grid rowIndex ${rowIndex} , cellIndex ${cellIndex} ${cell.toString()}');
        grid.array![rowIndex][cellIndex] = cell;
        } catch (e){
          print(e);
          rethrow;
        }
      }
    }

    print('next objectives');
    // Retrieve the objectives
    _objectives = (json["objective"] as List).map((item) {
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
  int get movesLeft => _movesLeft ?? 0;
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
    return (_movesLeft! - 1).clamp(0, _maxMoves);
  }
}
