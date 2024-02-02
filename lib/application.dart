import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game_bloc.dart';
import 'controllers/game_controller.dart';
import 'controllers/status_controller.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';

import 'bloc/gameover_bloc.dart';
import 'bloc/ready_bloc.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        
        RepositoryProvider(
          create: (_) => ReadyBloc(),
        ),
       RepositoryProvider(
          create: (_) => GameoverBloc(),
        ),
        RepositoryProvider(
          create: (_) => GameController(),
        ),
        RepositoryProvider(
          create: (_) => StatusController(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Crush',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
