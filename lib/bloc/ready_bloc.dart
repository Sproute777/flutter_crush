import 'package:rxdart/rxdart.dart';

class ReadyBloc {
   ReadyBloc();
  BehaviorSubject<bool> _readyToDisplayTilesController =
      BehaviorSubject<bool>();
  Function get setReadyToDisplayTiles =>
      _readyToDisplayTilesController.sink.add;
  Stream<bool> get outReadyToDisplayTiles =>
      _readyToDisplayTilesController.stream;
}
