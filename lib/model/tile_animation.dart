import 'row_col.dart';
import 'tile.dart';

/// Class which is used to register a Tile animation
class TileAnimation{
  TileAnimation({
    required this.animationType,
    required this.delay,
    required this.from,
    required this.to,
     this.tileType,
     this.tile,
  });

  final TileAnimationType animationType;
  final int delay;
  final RowCol from;
  final RowCol to;
  final TileType? tileType;
  TileOld? tile;
}

enum TileAnimationType {
  moveDown,
  avalanche,
  newTile,
  chain,
  collapse,
}