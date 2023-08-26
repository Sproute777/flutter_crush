import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';
// dev refactor
class GameBloc extends Bloc<GameEvent, GameState> {
  static double kMaxTilesPerRowAndColumn = 12.0;
  static double kMaxTilesSize = 28.0;

  GameBloc() : super(GameState()) {
    on<GameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
