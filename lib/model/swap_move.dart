// enum SwapDirections {
//   toRight(SwapMove(row: 0, col: 0)),
//   toLeft(SwapMove(row: 0, col: 0)),
//   toTop(SwapMove(row: 0, col: 0)),
//   toBottom(SwapMove(row: 0, col: 0));

//   final SwapMove swapMove;
//   const SwapDirections(this.swapMove);
// }

class SwapMove {
  final int row;
  final int col;

  const SwapMove({
    required this.row,
    required this.col,
  });
}
