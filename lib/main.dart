import 'dart:async';

import 'get_it.dart';
import 'startapp.dart';
import 'utils/guard_with_crashlytics.dart';

Future<void> main() async {
  // await Audio.init();
  await guardWithCrashlytics(() async{
    await configDependencies();
    startApp();
  });
}
