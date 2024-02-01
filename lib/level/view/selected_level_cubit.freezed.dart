// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_level_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SelectedLevelState {}

/// @nodoc

class _$$InitSelectedLevelImpl extends $InitSelectedLevel {
  const _$$InitSelectedLevelImpl() : super._();

  @override
  String toString() {
    return 'SelectedLevelState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$$InitSelectedLevelImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class $InitSelectedLevel extends SelectedLevelState {
  const factory $InitSelectedLevel() = _$$InitSelectedLevelImpl;
  const $InitSelectedLevel._() : super._();
}

/// @nodoc

class _$$SelectedLevelImpl extends $SelectedLevel {
  const _$$SelectedLevelImpl(this.level) : super._();

  @override
  final Level level;

  @override
  String toString() {
    return 'SelectedLevelState.loaded(level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$SelectedLevelImpl &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level);
}

abstract class $SelectedLevel extends SelectedLevelState {
  const factory $SelectedLevel(final Level level) = _$$SelectedLevelImpl;
  const $SelectedLevel._() : super._();

  Level get level;
}
