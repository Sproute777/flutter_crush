import 'dart:collection';
import 'tile.dart';

class Chain {
  // Number of tiles that compose the chain
  int length = 0;

  // Type of chain (horizontal or vertical)
  ChainType? type;

  // List of the tiles, part of the chain
  final _tiles = HashMap<int, TileOld?>();
  List<TileOld?> get tiles => _tiles.values.toList();

  // Constructor
  Chain({
    this.length = 0,
    this.type,
  });

  // Add a tile to the list of unique ones belonging to the chain
  void addTile(TileOld? tile){
    _tiles.putIfAbsent(tile.hashCode, () => tile);
    length = _tiles.length;
  }
}

//
// Types of chains
//
enum ChainType {
  horizontal,
  vertical,
}
