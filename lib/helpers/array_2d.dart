class Array2d<T> {
  List<List<T>>? array;
  T defaultValue;
   int _width;
   int _height;

  Array2d(int width, int height, { required this.defaultValue }): _width = width,_height = height{
_generated();
  } 

  void _generated(){
    array = List<List<T>>.empty(growable: true);
    array = List<List<T>>.generate(_width, (row) {
     return List<T>.generate(height, (col) =>  defaultValue);
   });
  }



  set width(int v) {
    if(array == null) {
      return;
    }
    _width = v;
    while (array!.length > v) {
      array!.removeLast();
    }
    while (array!.length < v) {
      final newList = <T>[];
      if (array!.isNotEmpty) {
        for (int y = 0; y < array!.first.length; y++) {
           newList.add(defaultValue!);
        }
      }
      array!.add(newList);
    }
  }

  set height(int v) {
    if(array == null) {
      return;
    }
    _height = v;
    while (array!.first.length > v) {
      for (int x = 0; x < array!.length; x++) {
        array![x].removeLast();
      }
    }
    while (array!.first.length < v) {
      for (int x = 0; x < array!.length; x++) {
        if (defaultValue != null) {
          array![x].add(defaultValue);
        }
      }
    }
  }

  int get width => _width;
  int get height => _height;

  //
  // Clone this Array2d
  //
Array2d copyWith({
  int? width,
  int? height,
  T? defaultValue,
}){
final newArray2d = Array2d<T>(width ?? this._width, height ?? this._height,
defaultValue: defaultValue ?? this.defaultValue);
newArray2d.array = List.from(this.array ?? [] ) ;
return newArray2d;
}

  // Array2d clone<T>() {
    // return copyWith<T>();
    // Array2d<T> newArray2d = Array2d<T>(_height, _width);

    // for (int row = 0; row < _height; row++) {
      // for (int col = 0; col < _width; col++) {
        // newArray2d.array![row][col] = (array![row][col] as T?);
      // }
    // }

    // return newArray2d;
  // }
}

String dumpArray2d(Array2d grid) {
  String string = '';
  for (int row = grid.height; row > 0; row--) {
    final values = <String>[];
    for (int col = 0; col < grid.width; col++) {
      final cell = grid.array![row - 1][col];
      values.add(cell == null ? ' ' : cell.toString());
    }
    string += '${values.join(' ')}\n';
  }
  return string;
}
