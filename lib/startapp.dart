import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crush/application.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver();
  static const tag = 'BlocObserver';
  final _log = Logger(tag);

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _log.info('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _log.warning('onError(${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> startApp() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);


  Bloc.observer = AppBlocObserver();

  runApp(Application());
}