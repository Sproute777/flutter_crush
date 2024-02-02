import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/typedef.dart';
part 'level_settings.g.dart';
part 'level_settings.freezed.dart';

@Freezed(toJson: false, fromJson: true)
class LevelSettings with _$LevelSettings {
  const LevelSettings._();
  const factory LevelSettings({
    @JsonKey(name: 'level') required int index,
    required int rows,
    required int cols,
    required int moves,
    @JsonKey(name: 'grid') required List<String> gridConfig,
    @JsonKey(name: 'objective') required List<String> aimConfig,
  }) = $LevelSettings;

  factory LevelSettings.fromJson(Json json) => _$LevelSettingsFromJson(json);
}

