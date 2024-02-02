// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$$LevelSettingsImpl _$$$LevelSettingsImplFromJson(Map<String, dynamic> json) =>
    _$$LevelSettingsImpl(
      id: LevelSettings._levelIdFromJson(json['level']),
      rows: json['rows'] as int,
      cols: json['cols'] as int,
      moves: json['moves'] as int,
      gridConfig:
          (json['grid'] as List<dynamic>).map((e) => e as String).toList(),
      aimConfig:
          (json['objective'] as List<dynamic>).map((e) => e as String).toList(),
    );
