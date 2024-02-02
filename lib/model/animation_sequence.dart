import 'tile.dart';
import 'tile_animation.dart';

class AnimationSequence {
  // Range of time for this sequence of animations
  int startDelay;
  int endDelay;

  // Type of tile in the sequence of animations
  TileType tileType;

  // List of all animations, part of the sequence
  List<TileAnimation> animations;

  // Constructor
  AnimationSequence({
    required this.tileType,
    required this.startDelay,
    required this.endDelay,
    required this.animations,
  });
}