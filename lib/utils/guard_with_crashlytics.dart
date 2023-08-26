// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:isolate';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

/// Runs [mainFunction] in a guarded [Zone].
///
/// If a non-null [FirebaseCrashlytics] instance is provided through
/// [crashlytics], then all errors will be reported through it.
///
/// These errors will also include latest logs from anywhere in the app
/// that use `package:logging`.
Future<void> guardWithCrashlytics(
  void Function() mainFunction, 
  // {
  // required FirebaseCrashlytics? crashlytics,
// }
) async {
  // Running the initialization code and [mainFunction] inside a guarded
  // zone, so that all errors (even those occurring in callbacks) are
  // caught and can be sent to Crashlytics.
  await runZonedGuarded<Future<void>>(() async {
    if (kDebugMode) {
      // Log more when in debug mode.
      Logger.root.level = Level.FINE;
    }
    // Subscribe to log messages. filter loggerName is here
    Logger.root.onRecord.listen((record) {
      final message = '${record.level.painted}'
          '[${record.time}]'
          '${record.loggerName}: '
          '${record.message}';

      debugPrint(message);
      // Add the message to the rotating Crashlytics log.
      // crashlytics?.log(message);

      if (record.level >= Level.SEVERE) {
        // debugPrint('$message ')
        // crashlytics?.recordError(message, filterStackTrace(StackTrace.current),
            // fatal: true);
      }
    });

    // Pass all uncaught errors from the framework to Crashlytics.
    // if (crashlytics != null) {
    //   WidgetsFlutterBinding.ensureInitialized();
    //   FlutterError.onError = crashlytics.recordFlutterFatalError;
    //   PlatformDispatcher.instance.onError = (error, stack) {
    //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //     return true;
    //   };
    // }
    // if (!kIsWeb) {
    //   // To catch errors outside of the Flutter context, we attach an error
    //   // listener to the current isolate.
    //   Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
    //     final errorAndStacktrace = pair as List<dynamic>;
    //     // await crashlytics?.recordError(
    //     //     errorAndStacktrace.first, errorAndStacktrace.last as StackTrace?,
    //     //     fatal: true);
    //   }).sendPort);
    // }

    // Run the actual code.
    mainFunction();
  }, (error, stack) {
    // This sees all errors that occur in the runZonedGuarded zone.
    debugPrint('ERROR: $error\n\n'
        'STACK:$stack');
    // crashlytics?.recordError(error, stack, fatal: true);
  });
}

/// Takes a [stackTrace] and creates a new one, but without the lines that
/// have to do with this file and logging. This way, Crashlytics won't group
/// all messages that come from this file into one big heap just because
/// the head of the StackTrace is identical.
///
/// See this:
/// https://stackoverflow.com/questions/47654410/how-to-effectively-group-non-fatal-exceptions-in-crashlytics-fabrics.
@visibleForTesting
StackTrace filterStackTrace(StackTrace stackTrace) {
  try {
    final lines = stackTrace.toString().split('\n');
    final buf = StringBuffer();
    for (final line in lines) {
      if (line.contains('crashlytics.dart') ||
          line.contains('_BroadcastStreamController.java') ||
          line.contains('logger.dart')) {
        continue;
      }
      buf.writeln(line);
    }
    return StackTrace.fromString(buf.toString());
  } catch (e) {
    debugPrint('Problem while filtering stack trace: $e');
  }

  // If there was an error while filtering,
  // return the original, unfiltered stack track.
  return stackTrace;
}

/// С†РІРµС‚Р° РґР»СЏ LEVEL РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ РјРѕРЅРѕС‚РѕРЅРЅС‹Рµ
extension LevelColor on Level {
  String get painted {
    if(name ==Level.FINE.name || name ==Level.FINER.name || name ==Level.FINEST.name){
      return '$_green$name$_reset';
    }
    if (name == Level.INFO.name) {
      return '$_cyan$name$_reset';
    } else if (name == Level.WARNING.name) {
      return '$_red$name$_reset';
    } else if (name == Level.SEVERE.name) {
      return '$_red$name$_reset';
    } else if (name == Level.SHOUT.name) {
      return '$_red$name$_reset';
    } else {
      return name;
    }
  }
}

// const _black = '\x1B[30m';
const _red = '\x1B[31m';
const _green = '\x1B[32m';
// const _yellow = '\x1B[33m';
// const _blue = '\x1B[34m';
// const _magenta = '\x1B[35m';
const _cyan = '\x1B[36m';
// const _white = '\x1B[37m';
const _reset = '\x1B[0m';