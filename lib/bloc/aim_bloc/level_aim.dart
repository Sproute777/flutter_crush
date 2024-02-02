import 'package:equatable/equatable.dart';
import '../../model/tile.dart';

class LevelAim extends Equatable {
  final TileType type;
  final int count;
  final int initialValue;
  final bool completed;
  const LevelAim({
    required this.type,
    required this.count,
    required this.initialValue,
    required this.completed,
  });

  @override
  List<Object?> get props => [count, initialValue, type, completed];

  LevelAim copyWith(
      {TileType? type, int? count, int? initialValue, bool? completed}) {
    return LevelAim(
        type: type ?? this.type,
        count: count ?? this.count,
        initialValue: initialValue ?? this.initialValue,
        completed: completed ?? this.completed);
  }
}
