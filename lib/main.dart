import 'dart:async';

import 'utils/guard_with_crashlytics.dart';

import 'get_it.dart';
import 'startapp.dart';

Future<void> main() async {
  // await Audio.init();
  await guardWithCrashlytics(() async{
    await configDependencies();
    startApp();
  });
}
