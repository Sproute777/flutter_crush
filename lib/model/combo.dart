import 'dart:collection';

import 'chain.dart';
import 'tile.dart';

class Combo {
  // List of all the tiles, part of the combo
  final HashMap<int, TileOld?> _tiles = HashMap<int, TileOld?>();
  List<TileOld?> get tiles => UnmodifiableListView(_tiles.values.toList());

  // Type of combo
  ComboType _type = ComboType.none;
  ComboType get type => _type;

  // Type of tile that results from the combo
  late TileType resultingTileType;

  // Which tile is responsible for the combo
  TileOld? commonTile;

  // Constructor
  Combo(Chain? horizontalChain, Chain? verticalChain, int row, int col) {
    horizontalChain?.tiles.forEach((TileOld? tile) {
      _tiles.putIfAbsent(tile.hashCode, () => tile);
    });
    verticalChain?.tiles.forEach((TileOld? tile) {
      if (commonTile == null && _tiles.keys.contains(tile.hashCode)) {
        commonTile = tile;
      }
      _tiles.putIfAbsent(tile.hashCode, () => tile);
    });

    int total = _tiles.length;
    _type = ComboType.values[total];

    // If the combo contains more than 3 tiles but is not the combination of both horizontal and vertical chains
    // we need to determine the tile which created the chain
    if (total > 3 && commonTile == null) {
      for (final tile in _tiles.values) {
        if (tile != null && tile.row == row && tile.col == col) {
          commonTile = tile;
        }
      }
    }

    // Determine the type of the resulting tile (case of more than 3 tiles)
    switch (total) {
      case 4:
        resultingTileType = TileType.flare;

      case 6:
        resultingTileType = TileType.bomb;

      case 5:
        resultingTileType = TileType.wrapped;

      case 7:
        resultingTileType = TileType.fireball;
    }
  }
}

//
// All combo types
//
enum ComboType {
  none,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
}
