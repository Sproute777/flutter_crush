// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LevelSettings _$LevelSettingsFromJson(Map<String, dynamic> json) {
  return $LevelSettings.fromJson(json);
}

/// @nodoc
mixin _$LevelSettings {
  @JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
  LevelId get id => throw _privateConstructorUsedError;
  int get rows => throw _privateConstructorUsedError;
  int get cols => throw _privateConstructorUsedError;
  int get moves => throw _privateConstructorUsedError;
  @JsonKey(name: 'grid')
  List<String> get gridConfig => throw _privateConstructorUsedError;
  @JsonKey(name: 'objective')
  List<String> get aimConfig => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LevelSettingsCopyWith<LevelSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelSettingsCopyWith<$Res> {
  factory $LevelSettingsCopyWith(
          LevelSettings value, $Res Function(LevelSettings) then) =
      _$LevelSettingsCopyWithImpl<$Res, LevelSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
      LevelId id,
      int rows,
      int cols,
      int moves,
      @JsonKey(name: 'grid') List<String> gridConfig,
      @JsonKey(name: 'objective') List<String> aimConfig});
}

/// @nodoc
class _$LevelSettingsCopyWithImpl<$Res, $Val extends LevelSettings>
    implements $LevelSettingsCopyWith<$Res> {
  _$LevelSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rows = null,
    Object? cols = null,
    Object? moves = null,
    Object? gridConfig = null,
    Object? aimConfig = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as LevelId,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      cols: null == cols
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as int,
      moves: null == moves
          ? _value.moves
          : moves // ignore: cast_nullable_to_non_nullable
              as int,
      gridConfig: null == gridConfig
          ? _value.gridConfig
          : gridConfig // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aimConfig: null == aimConfig
          ? _value.aimConfig
          : aimConfig // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$LevelSettingsImplCopyWith<$Res>
    implements $LevelSettingsCopyWith<$Res> {
  factory _$$$LevelSettingsImplCopyWith(_$$LevelSettingsImpl value,
          $Res Function(_$$LevelSettingsImpl) then) =
      __$$$LevelSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
      LevelId id,
      int rows,
      int cols,
      int moves,
      @JsonKey(name: 'grid') List<String> gridConfig,
      @JsonKey(name: 'objective') List<String> aimConfig});
}

/// @nodoc
class __$$$LevelSettingsImplCopyWithImpl<$Res>
    extends _$LevelSettingsCopyWithImpl<$Res, _$$LevelSettingsImpl>
    implements _$$$LevelSettingsImplCopyWith<$Res> {
  __$$$LevelSettingsImplCopyWithImpl(
      _$$LevelSettingsImpl _value, $Res Function(_$$LevelSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rows = null,
    Object? cols = null,
    Object? moves = null,
    Object? gridConfig = null,
    Object? aimConfig = null,
  }) {
    return _then(_$$LevelSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as LevelId,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      cols: null == cols
          ? _value.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as int,
      moves: null == moves
          ? _value.moves
          : moves // ignore: cast_nullable_to_non_nullable
              as int,
      gridConfig: null == gridConfig
          ? _value._gridConfig
          : gridConfig // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aimConfig: null == aimConfig
          ? _value._aimConfig
          : aimConfig // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$$LevelSettingsImpl extends $LevelSettings {
  const _$$LevelSettingsImpl(
      {@JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
      required this.id,
      required this.rows,
      required this.cols,
      required this.moves,
      @JsonKey(name: 'grid') required final List<String> gridConfig,
      @JsonKey(name: 'objective') required final List<String> aimConfig})
      : _gridConfig = gridConfig,
        _aimConfig = aimConfig,
        super._();

  factory _$$LevelSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$$LevelSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
  final LevelId id;
  @override
  final int rows;
  @override
  final int cols;
  @override
  final int moves;
  final List<String> _gridConfig;
  @override
  @JsonKey(name: 'grid')
  List<String> get gridConfig {
    if (_gridConfig is EqualUnmodifiableListView) return _gridConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gridConfig);
  }

  final List<String> _aimConfig;
  @override
  @JsonKey(name: 'objective')
  List<String> get aimConfig {
    if (_aimConfig is EqualUnmodifiableListView) return _aimConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_aimConfig);
  }

  @override
  String toString() {
    return 'LevelSettings(id: $id, rows: $rows, cols: $cols, moves: $moves, gridConfig: $gridConfig, aimConfig: $aimConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$LevelSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rows, rows) || other.rows == rows) &&
            (identical(other.cols, cols) || other.cols == cols) &&
            (identical(other.moves, moves) || other.moves == moves) &&
            const DeepCollectionEquality()
                .equals(other._gridConfig, _gridConfig) &&
            const DeepCollectionEquality()
                .equals(other._aimConfig, _aimConfig));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rows,
      cols,
      moves,
      const DeepCollectionEquality().hash(_gridConfig),
      const DeepCollectionEquality().hash(_aimConfig));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$$LevelSettingsImplCopyWith<_$$LevelSettingsImpl> get copyWith =>
      __$$$LevelSettingsImplCopyWithImpl<_$$LevelSettingsImpl>(
          this, _$identity);
}

abstract class $LevelSettings extends LevelSettings {
  const factory $LevelSettings(
          {@JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
          required final LevelId id,
          required final int rows,
          required final int cols,
          required final int moves,
          @JsonKey(name: 'grid') required final List<String> gridConfig,
          @JsonKey(name: 'objective') required final List<String> aimConfig}) =
      _$$LevelSettingsImpl;
  const $LevelSettings._() : super._();

  factory $LevelSettings.fromJson(Map<String, dynamic> json) =
      _$$LevelSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'level', fromJson: LevelSettings._levelIdFromJson)
  LevelId get id;
  @override
  int get rows;
  @override
  int get cols;
  @override
  int get moves;
  @override
  @JsonKey(name: 'grid')
  List<String> get gridConfig;
  @override
  @JsonKey(name: 'objective')
  List<String> get aimConfig;
  @override
  @JsonKey(ignore: true)
  _$$$LevelSettingsImplCopyWith<_$$LevelSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
