
import 'package:freezed_annotation/freezed_annotation.dart';
part 'ids.freezed.dart';

@Freezed(copyWith: false)
class LevelId with _$LevelId {
  const LevelId._();
  const factory LevelId({
    required int index,
  }) = _LevelId;
}
