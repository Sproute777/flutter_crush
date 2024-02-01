import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../model/level.dart';
import '../domain/level_interactor.dart';

part 'levels_cubit.freezed.dart';

@injectable
class LevelsCubit extends Cubit<LevelsState> {
  LevelsCubit(this._interactor) : super(const LevelsState([]));
  StreamSubscription? _subscription;
  final LevelInteractor _interactor;

  void init() {
    _subscription =
        _interactor.levelsStream.map<LevelsState>(LevelsState.new).listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}

@Freezed(
    map: FreezedMapOptions.none, when: FreezedWhenOptions.none, copyWith: false)
 class LevelsState with _$LevelsState {
  const LevelsState._();
  const factory LevelsState(List<Level> levels) = LoadedLevelsState;
}
