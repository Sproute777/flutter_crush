import 'tile.dart';

/// Identifies a possible swap between 2 tiles
class Swap extends Object {
  TileOld from;
  TileOld to;
  
  Swap({
    required this.from,
    required this.to,
  });
  
  @override
  int get hashCode => from.hashCode * 1000 + to.hashCode;

  @override
  bool operator==(dynamic other){
    return identical(other, this) || other.hashCode == hashCode;
  }
}
