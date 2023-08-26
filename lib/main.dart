import 'dart:async';

import 'package:flutter_crush/utils/guard_with_crashlytics.dart';

import 'startapp.dart';

Future<void> main() async {
  //
  // Initialize the audio
  //
  // await Audio.init();

  //
  // Remove the status bar
  //
    await guardWithCrashlytics(() {
    startApp();
  });

  }
