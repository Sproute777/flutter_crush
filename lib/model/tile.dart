import 'dart:math' as math;
import 'package:flutter_crush/gen/assets.gen.dart';
import 'package:flutter_crush/model/level.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;

class TileNew extends StatefulWidget {
  final TileType type;
  final int row;
  final int col;
  final Level level;
  final int depth;
  final double x;
  final double y;

  const TileNew({
    super.key,
     this.type = TileType.empty,
    this.row = 0,
    this.col = 0,
     required this.level ,
    this.depth = 0,
    this.x = 0,
    this.y = 0,
  });

  @override
  State<TileNew> createState() => _TileNewState();
}

class _TileNewState extends State<TileNew> {
 late final TileType type;
 late int depth;
 late double x;
 late double y;
  bool visible = true;
  bool computePosition = true;

  @override
  void initState() {
    super.initState();
    x = widget.x;
    y = widget.y;
    depth = widget.depth;
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && type != TileType.wall) {
      return Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            child: Transform.scale(
              scale: 0.8,
              child: _buildDecoration(),
            ),
          ),
          _buildDecoration(MyAssets.images.deco.ice02.path),
        ],
      );
    } else if (type == TileType.empty) {
      return SizedBox();
    } else {
      return _buildDecoration();
    }
  }

  Widget _buildDecoration([String path = ""]) {
    String imageAsset = path;
    if (imageAsset == "") {
      switch (type) {
        case TileType.wall:
          imageAsset = MyAssets.images.deco.wall.path;
          break;

        case TileType.bomb:
          imageAsset = MyAssets.images.bombs.mine.path;
          break;

        case TileType.flare:
          imageAsset = MyAssets.images.bombs.tnt.path;
          break;

        case TileType.wrapped:
          imageAsset = MyAssets.images.tiles.multicolor.path;
          break;

        case TileType.fireball:
          imageAsset = MyAssets.images.bombs.rocket.path;
          break;

        case TileType.blue:
          imageAsset = MyAssets.images.tiles.blue.path;
          break;
        case TileType.green:
          imageAsset = MyAssets.images.tiles.green.path;
          break;
        case TileType.orange:
          imageAsset = MyAssets.images.tiles.orange.path;
          break;
        case TileType.purple:
          imageAsset = MyAssets.images.tiles.purple.path;
          break;
        case TileType.red:
          imageAsset = MyAssets.images.tiles.red.path;
          break;
        case TileType.yellow:
          imageAsset = MyAssets.images.tiles.yellow.path;
          break;
        case TileType.forbidden:
        case TileType.empty:
        case TileType.last:
          break;
      }
    }
    if (imageAsset == '') return SizedBox();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(imageAsset),
        fit: BoxFit.contain,
      )),
    );
  }

  //
  // Returns the position of this tile in the checkerboard
  // based on its position in the grid (row, col) and
  // the dimensions of the board and a tile
  //
  void setPosition() {
    final level = widget.level;
    double bottom =
        level.boardTop + (level.numberOfRows - 1) * level.tileHeight;
    x = level.boardLeft + widget.col * level.tileWidth;
    y = bottom - widget.row * level.tileHeight;
    if (mounted) setState(() {});
  }
}

//------------------------------
class TileOld extends Object {
  TileType? type;
  int row;
  int col;
  Level? level;
  int depth;
  late Widget _widget;
  late double x;
  late double y;
  bool visible;

  TileOld({
    required this.type,
    this.row = 0,
    this.col = 0,
    this.level,
    this.depth = 0,
    this.visible = true,
  });

  @override
  int get hashCode => row * (level?.numberOfRows ?? 0) + col;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || other.hashCode == this.hashCode;
  }

  @override
  String toString() {
    return '[$row][$col] => ${type}';
  }

  //
  // Builds the tile in terms of "decoration" ( = image )
  //
  void build({bool computePosition = true}) {
    if (depth > 0 && type != TileType.wall) {
      _widget = Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            child: Transform.scale(
              scale: 0.8,
              child: _buildDecoration(type!),
            ),
          ),
          _buildDecoration(type!, MyAssets.images.deco.ice02.path),
        ],
      );
    } else if (type == TileType.empty) {
      _widget = SizedBox();
    } else {
      _widget = _buildDecoration(type!);
    }

    if (computePosition) {
      setPosition();
    }
  }

  Widget _buildDecoration(TileType tileType, [String path = ""]) {
    String imageAsset = path;
    if (imageAsset == "") {
      switch (tileType) {
        case TileType.wall:
          imageAsset = MyAssets.images.deco.wall.path;
          break;

        case TileType.bomb:
          imageAsset = MyAssets.images.bombs.mine.path;
          break;

        case TileType.flare:
          imageAsset = MyAssets.images.bombs.tnt.path;
          break;

        case TileType.wrapped:
          imageAsset = MyAssets.images.tiles.multicolor.path;
          break;

        case TileType.fireball:
          imageAsset = MyAssets.images.bombs.rocket.path;
          break;

        case TileType.blue:
          imageAsset = MyAssets.images.tiles.blue.path;
          break;
        case TileType.green:
          imageAsset = MyAssets.images.tiles.green.path;
          break;
        case TileType.orange:
          imageAsset = MyAssets.images.tiles.orange.path;
          break;
        case TileType.purple:
          imageAsset = MyAssets.images.tiles.purple.path;
          break;
        case TileType.red:
          imageAsset = MyAssets.images.tiles.red.path;
          break;
        case TileType.yellow:
          imageAsset = MyAssets.images.tiles.yellow.path;
          break;
        case TileType.forbidden:
        case TileType.empty:
        case TileType.last:
          break;
      }
    }
    if (imageAsset == '') return SizedBox();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(imageAsset),
        fit: BoxFit.contain,
      )),
    );
  }

  //
  // Returns the position of this tile in the checkerboard
  // based on its position in the grid (row, col) and
  // the dimensions of the board and a tile
  //
  void setPosition() {
    if (level == null) return;
    double bottom =
        level!.boardTop + (level!.numberOfRows - 1) * level!.tileHeight;
    x = level!.boardLeft + col * level!.tileWidth;
    y = bottom - row * level!.tileHeight;
  }

  //
  // Generate a tile to be used during the swap animations
  //
  TileOld cloneForAnimation() {
    TileOld tile = TileOld(level: level, type: type, row: row, col: col);
    tile.build();

    return tile;
  }

  //
  // Swaps this tile (row, col) with the ones of another Tile
  //
  void swapRowColWith(TileOld destTile) {
    int tft = destTile.row;
    Logger.root.fine('Tile tft ${destTile.row} ${destTile.col}');
    destTile.row = row;
    row = tft;
    tft = destTile.col;
    destTile.col = col;
    Logger.root.fine('Tile destTile ${destTile.row} ${destTile.col} ');
    col = tft;
  }

  //
  // Returns the Widget to be used to render the Tile
  //
  Widget get widget => getWidgetSized(level!.tileWidth, level!.tileHeight);

  Widget getWidgetSized(double width, double height) => Container(
        width: width,
        height: height,
        child: _widget,
      );

  //
  // Can the Tile move?
  //
  bool get canMove => (depth == 0) && (canBePlayed(type));

  //
  // Can a Tile fall?
  //
  bool get canFall =>
      type != TileType.wall &&
      type != TileType.forbidden &&
      type != TileType.empty;

  // ################  HELPERS  ######################
  //
  // Generate a random tile
  //
  static TileType random(math.Random rnd) {
    int minValue = _firstNormalTile;
    int maxValue = _lastNormalTile;
    int value = rnd.nextInt(maxValue - minValue) + minValue;
    return TileType.values[value];
  }

  static int get _firstNormalTile => TileType.red.index;
  static int get _lastNormalTile => TileType.yellow.index;
  static int get _firstBombTile => TileType.bomb.index;
  static int get _lastBombTile => TileType.fireball.index;

  static bool isNormal(TileType? type) {
    int? index = type?.index;
    if (index == null) return false;
    return (index >= _firstNormalTile && index <= _lastNormalTile);
  }

  static bool isBomb(TileType? type) {
    int? index = type?.index;
    if (index == null) return false;
    return (index >= _firstBombTile && index <= _lastBombTile);
  }

  static bool canBePlayed(TileType? type) =>
      (type != TileType.wall && type != TileType.forbidden);
}

enum TileType {
  forbidden,
  empty,
  red,
  green,
  blue,
  orange,
  purple,
  yellow,
  wall,
  bomb,
  flare,
  wrapped,
  fireball,
  last,
}
