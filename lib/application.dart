// import 'package:flutter_crush/bloc/bloc_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crush/bloc/game_bloc.dart';
import 'package:flutter_crush/controllers/game_controller.dart';
import 'package:flutter_crush/pages/home_page.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => GameBloc(),
        ),
        RepositoryProvider(
          create: (context) => GameController(),
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
