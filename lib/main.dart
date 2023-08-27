import 'dart:async';

import 'package:flutter_crush/utils/guard_with_crashlytics.dart';

import 'startapp.dart';

Future<void> main() async {
  // await Audio.init();
    await guardWithCrashlytics(() {
    startApp();
  });

  }
