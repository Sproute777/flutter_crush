import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../model/level.dart';
import '../domain/level_interactor.dart';

part 'selected_level_cubit.freezed.dart';

@injectable
class SelectedLevel extends Cubit<SelectedLevelState> {
  SelectedLevel(this._interactor) : super(const SelectedLevelState.init());
  StreamSubscription? _subscription;
  final LevelInteractor _interactor;

  void init() {
    _subscription = _interactor.selectedLevelStream.map<SelectedLevelState>((level) {
      if (level == null) {
        return const SelectedLevelState.init();
      }
      return SelectedLevelState.loaded(level);
    }).listen(emit);
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
sealed class SelectedLevelState with _$SelectedLevelState {
  const SelectedLevelState._();
  const factory SelectedLevelState.init() = $InitSelectedLevel;
  const factory SelectedLevelState.loaded(Level level) = $SelectedLevel;
}
