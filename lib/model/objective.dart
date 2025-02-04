// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'tile.dart';

///
/// Objective
///
/// One objective for a level.
/// 
class Objective extends Object {
  late TileType type;
  int count = 0;
  int initialValue = 0;
  bool completed = false;

  // Constructor
  Objective(String string){
    final parts = string.split(';');
    
    // Retrieve the type by its name (as a string)
    type = TileType.values.firstWhere((e)=> e.toString().split('.')[1] == parts[1]);
    initialValue = int.parse(parts[0]);

    reset();
  }

  @override
  bool operator==(dynamic other) => identical(this, other) || type == other.type;

  @override
  int get hashCode => type.index;



  //
  // Decrements the number of times this objective needs to be met.
  // Once the objective has been reached, sets it to "completed"
  // 
  void decrement(int value){
    count -= value;
    if (count <= 0){
      completed = true;
      count = 0;
    }
  }

  //
  // Reset of the counter of the objective
  // at start of a new game
  //
  void reset(){
    count = initialValue;
  }

@override
String toString() {
    return 'Objective{type=$type, count=$count, initialValue=$initialValue, completed=$completed}';
  }
}
