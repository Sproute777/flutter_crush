import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/tile.dart';
import 'level_aim.dart';

part 'level_aim_event.dart';
part 'level_aim_state.dart';

class LevelAimBloc extends Bloc<LevelAimEvent, LevelAimState> {
  LevelAimBloc() : super(LevelAimState()) {
    on<DecrementLevelAim>(_onDecrement);
  }


Future<void> _onDecrement(DecrementLevelAim event,Emitter<LevelAimState> emit)async{
  try{
  final index = state.levelAims.indexWhere((a)=> a.type == event.type);
  final aim = state.levelAims[index];
  final newAim = aim.copyWith(count: aim.count - 1 );
  emit(state.copyWith(levelAims: List.of(state.levelAims)..[index] = newAim));
  }
  catch (e,stack){
    addError(e,stack);
  }
}

}
