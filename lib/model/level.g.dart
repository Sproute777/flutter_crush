// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelSettings _$LevelSettingsFromJson(Map<String, dynamic> json) =>
    LevelSettings(
      index: json['level'] as int,
      rows: json['rows'] as int,
      cols: json['cols'] as int,
      moves: json['moves'] as int,
      gridConfig:
          (json['grid'] as List<dynamic>).map((e) => e as String).toList(),
      aimConfig:
          (json['objective'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LevelSettingsToJson(LevelSettings instance) =>
    <String, dynamic>{
      'level': instance.index,
      'rows': instance.rows,
      'cols': instance.cols,
      'moves': instance.moves,
      'grid': instance.gridConfig,
      'objective': instance.aimConfig,
    };
