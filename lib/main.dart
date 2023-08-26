import 'dart:async';

import 'package:flutter_crush/application.dart';
import 'package:flutter_crush/helpers/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  //
  // Initialize the audio
  //
  // await Audio.init();

  //
  // Remove the status bar
  //
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      await Future<void>.delayed(Duration(milliseconds: 100));
      FlutterError.onError = (details) {
        print(details.exceptionAsString());
        print(details.stack);
      };

      runApp(
        Application(),
      );
    },
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );
}
