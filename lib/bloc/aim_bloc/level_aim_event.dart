part of 'level_aim_bloc.dart';

sealed class LevelAimEvent extends Equatable {
  const LevelAimEvent();

  @override
  List<Object> get props => [];
}


final class DecrementLevelAim extends LevelAimEvent{
  const DecrementLevelAim(this.type);
  final TileType type;
}
