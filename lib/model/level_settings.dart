import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/typedef.dart';
import 'ids.dart';
part 'level_settings.g.dart';
part 'level_settings.freezed.dart';

@Freezed(toJson: false, fromJson: true)
class LevelSettings with _$LevelSettings {
  const LevelSettings._();
  const factory LevelSettings({
    @JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
    required LevelId id,
    required int rows,
    required int cols,
    required int moves,
    @JsonKey(name: 'grid') required List<String> gridConfig,
    @JsonKey(name: 'objective') required List<String> aimConfig,
  }) = $LevelSettings;

  factory LevelSettings.fromJson(Json json) => _$LevelSettingsFromJson(json);

  static LevelId _levelIdFromJson(dynamic data) {
    if (data is int) {
      return LevelId(index: data);
    }
    throw Exception('_levelIdFromJson() not found expected value');
  }
}
