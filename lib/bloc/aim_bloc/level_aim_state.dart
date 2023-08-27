part of 'level_aim_bloc.dart';

final class LevelAimState extends Equatable {
  final  List<LevelAim> levelAims;
    LevelAimState({
     this.levelAims = const <LevelAim>[],
  });

  
  @override
  List<Object> get props => [levelAims];
  LevelAimState copyWith({
    List<LevelAim>? levelAims    
  }) {
    return LevelAimState(
          levelAims: levelAims ?? this.levelAims
    );
  }
}

