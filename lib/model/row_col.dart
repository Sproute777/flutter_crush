import 'package:equatable/equatable.dart';

class RowCol extends Equatable {
  final int row;
  final int col;

  const RowCol({
    required this.row,
    required this.col,
  });

  
  @override
  List<Object?> get props => [row,col];
}
