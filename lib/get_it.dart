import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'get_it.config.dart';

final getIt = GetIt.I;

const ios = Environment('ios');
const web = Environment('web');
const android = Environment('android');

@InjectableInit(initializerName: r'init')
Future<void> configDependencies() async {
  // await Future.wait([Shared.init(), Config.initialize()]);
  await Future<void>.delayed(Duration.zero);
  getIt.init();
}

String get environment {
  if (kIsWeb) {
    return web.name;
  }
  if (Platform.isIOS) {
    return ios.name;
  }
  if (Platform.isAndroid) {
    return android.name;
  }
  return 'other';
}

@module
abstract class RegisterModule {

  // @lazySingleton
  // DatabaseClient get localDatabase => DatabaseClient();
}
