part of 'game_bloc.dart';

class GameState extends Equatable {
  final bool readyToDisplayTilesController;

  GameState({
    this.readyToDisplayTilesController = false,
  });

  @override
  List<Object?> get props => [];
}
