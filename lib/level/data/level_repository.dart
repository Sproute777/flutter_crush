import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../model/level.dart';
import '../../model/level_settings.dart';

abstract class ILevelRepository {
  Future<List<Level>> loadLevels();
}

@Injectable(as: ILevelRepository)
class LevelRepository implements ILevelRepository {
  @override
  Future<List<Level>> loadLevels() async {
    try {
      String jsonContent = await rootBundle.loadString('assets/levels.json');
      final list = jsonDecode(jsonContent) as Map<String, dynamic>;
      debugPrint(list.toString());
      final levels = List<Level>.empty(growable: true);
      for (final levelItem in list['levels'] as List) {
        debugPrint(levelItem.toString());
        try {
          final settings = LevelSettings.fromJson(levelItem);
          final l = Level.fromSettings(settings);
          levels.add(l);
        } catch (e, _) {
          debugPrint(
            'crash during parse fromJson',
          );
        }
      }
      return levels;
    } catch (e, _) {
      debugPrint(
        'crash during loading assets',
      );
      return [];
    }
  }
}
