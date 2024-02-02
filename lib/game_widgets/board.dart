import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' hide Level;

import '../bloc/ready_bloc.dart';
import '../controllers/game_controller.dart';
import '../helpers/array_2d.dart';
import '../level/domain/level_const.dart';
import '../model/level.dart';

class Board extends StatefulWidget {
  Board({
    Key? key,
    this.cols = 0,
    this.rows = 0,
    required this.levelNtf,
  }) : super(key: key);

  final int rows;
  final int cols;
  final ValueNotifier<Level?> levelNtf;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Array2d<BoxDecoration?>? _decorations;

  Array2d<Color?>? _checker;

  GlobalKey _keyChecker = GlobalKey();

  GlobalKey _keyCheckerCell = GlobalKey();

  // GameBloc? gameBloc;
  GameController? gameController;
  ReadyBloc? readyBloc;

  void _buildDecorations() {
    if (_decorations != null) return;
    _decorations = Array2d<BoxDecoration?>(widget.cols + 1, widget.rows + 1,
        defaultValue: null);

    Logger.root.info('_buildDecorations');
    for (int row = 0; row <= widget.rows; row++) {
      for (int col = 0; col <= widget.cols; col++) {
        // If there is nothing at (row, col) => no decoration
        int topLeft = 0;
        int bottomLeft = 0;
        int topRight = 0;
        int bottomRight = 0;
        BoxDecoration? boxDecoration;

        if (col > 0) {
          if (row < widget.rows) {
            if (widget.levelNtf.value!.grid.array![row][col - 1] != 'X') {
              topLeft = 1;
            }
          }
          if (row > 0) {
            if (widget.levelNtf.value!.grid.array![row - 1][col - 1] != 'X') {
              bottomLeft = 1;
            }
          }
        }

        if (col < widget.cols) {
          if (row < widget.rows) {
            if (widget.levelNtf.value!.grid.array![row][col] != 'X') {
              topRight = 1;
            }
          }
          if (row > 0) {
            if (widget.levelNtf.value!.grid.array![row - 1][col] != 'X') {
              bottomRight = 1;
            }
          }
        }

        int value = topLeft;
        value |= (topRight << 1);
        value |= (bottomLeft << 2);
        value |= (bottomRight << 3);

        if (value != 0 && value != 6 && value != 9) {
          boxDecoration = BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/borders/border_$value.png'),
                fit: BoxFit.cover),
          );
        }
        _decorations?.array?[row][col] = boxDecoration;
      }
    }
  }

  void _buildChecker() {
    if (_checker != null) return;

    Logger.root.info('_buildChecker');
    _checker = Array2d<Color?>(widget.rows, widget.cols, defaultValue: null);
    int counter = 0;

    for (int row = 0; row < widget.rows; row++) {
      counter = (row % 2 == 1) ? 0 : 1;
      for (int col = 0; col < widget.cols; col++) {
        final double opacity = ((counter + col) % 2 == 1) ? 0.3 : 0.1;

        Color color = (widget.levelNtf.value!.grid.array![row][col] == 'X')
            ? Colors.transparent
            : Colors.white.withOpacity(opacity);

        _checker?.array![row][col] = color;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    gameController = RepositoryProvider.of<GameController>(context);
    readyBloc = RepositoryProvider.of<ReadyBloc>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxDimension = math.min(screenSize.width, screenSize.height);
    final double maxTileWidth = math.min(
        maxDimension / LevelConst.kMaxTilesPerRowAndColumn,
        LevelConst.kMaxTilesSize);

    WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild());

    // As the GridView.builder builds top to bottom
    // and we need to compute the decorations bottom up
    // we need to do it at first
    _buildDecorations();
    _buildChecker();

    //
    // Dimensions of the board
    //
    final double width = maxTileWidth * (widget.cols + 1) * 1.1;
    final double height = maxTileWidth * (widget.rows + 1) * 1.1;

    return ValueListenableBuilder(
        valueListenable: gameController!.levelNtf,
        builder: (context, level, _) {
          return Container(
            padding: const EdgeInsets.all(0.0),
            width: width,
            height: height,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                _showDecorations(maxTileWidth),
                _showGrid(
                    maxTileWidth), // We pass the gameBloc since we will need to use it to pass the dimensions and coordinates
              ],
            ),
          );
        });
  }

  Widget _showDecorations(double width) {
    Logger.root.info('_showDecorations');
    return GridView.builder(
      padding: const EdgeInsets.all(0.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.cols + 1,
        childAspectRatio: 1.01,
      ),
      itemCount: (widget.cols + 1) * (widget.rows + 1),
      itemBuilder: (BuildContext context, int index) {
        final int col = index % (widget.cols + 1);
        final int row = (index / (widget.cols + 1)).floor();

        //
        // Use the decoration from bottom up during this build
        //
        return Container(
            decoration: _decorations?.array![widget.rows - row][col]);
      },
    );
  }

  //
  Widget _showGrid(double width) {
    bool isFirst = true;

    Logger.root.info('_showGrid');
    return Padding(
      padding: EdgeInsets.all(width * 0.6),
      child: GridView.builder(
        key: _keyChecker,
        padding: const EdgeInsets.all(0.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.cols,
          childAspectRatio: 1.01, // 1.01 solves an issue with floating numbers
        ),
        itemCount: widget.cols * widget.rows,
        itemBuilder: (BuildContext context, int index) {
          final int col = index % widget.cols;
          final int row = (index / widget.cols).floor();

          return Container(
            color: _checker!.array![widget.rows - row - 1][col],
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              if (isFirst) {
                isFirst = false;
                return Container(key: _keyCheckerCell);
              }
              return Container();
            }),
          );
        },
      ),
    );
  }

  //
  Rect _getDimensionsFromContext(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    final Offset topLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
    final Offset bottomRight =
        box.size.bottomRight(box.localToGlobal(Offset.zero));
    return Rect.fromLTRB(
        topLeft.dx, topLeft.dy, bottomRight.dx, bottomRight.dy);
  }

  //
  void _afterBuild() {
    Logger.root.info('_afterBuild');
    //
    // Let's get the dimensions and position of the exact position of the board
    //
    if (_keyChecker.currentContext != null) {
      final Rect rectBoard =
          _getDimensionsFromContext(_keyChecker.currentContext!);

      //
      // Save the position of the board
      //

      //  Logger.root.info('_afterBuild top${rectBoard.top}');
      //  Logger.root.info('_afterBuild left ${rectBoard.left}');
      gameController!
        ..setBoardTop(rectBoard.top)
        ..setBoardLeft(rectBoard.left);

      //
      // Let's get the dimensions of one cell of the board
      //
      final Rect rectBoardSquare =
          _getDimensionsFromContext(_keyCheckerCell.currentContext!);

      //
      // Save it for later reuse
      //
      gameController!
        ..setTileWidth(rectBoardSquare.width)
        ..setTileHeight(rectBoardSquare.height);

      //
      // Send a notification to inform that we are ready to display the tiles from now on
      //
      readyBloc!.setReadyToDisplayTiles(true);
      // setState(() {

      // });
    }
  }
}
