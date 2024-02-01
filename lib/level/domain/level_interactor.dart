import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:rxdart/rxdart.dart';

import '../../model/level.dart';
import '../data/level_repository.dart';

@lazySingleton
class LevelInteractor {
  LevelInteractor(this._iLevelRepository) {
    _init();
  }
  final ILevelRepository _iLevelRepository;
  //----------------------------------------------

  late final Logger _log = Logger('$runtimeType');
  late final _selectedLevelSubject = BehaviorSubject.seeded(null);
  late final _levelsSubject = BehaviorSubject.seeded(const <Level>[]);
  Stream<Level?> get selectedLevelStream => _selectedLevelSubject.stream;
  Stream<List<Level>> get levelsStream => _levelsSubject.stream;
//-----------------------------------------------

  Future<void> _init() async {
    final levels = await _iLevelRepository.loadLevels();
    debugPrint('levels: ---> ${levels.length}');
    _levelsSubject.add(levels);
  }

//---------------------------------------------------
  @disposeMethod
  void dispose() {
    _log.children.remove('$runtimeType');
  }
}
