import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crush/bloc/game_bloc.dart';
import 'package:flutter_crush/game_widgets/double_curved_container.dart';
import 'package:flutter_crush/game_widgets/game_level_button.dart';
import 'package:flutter_crush/game_widgets/shadowed_text.dart';
import 'package:flutter_crush/model/level.dart';
import 'package:flutter_crush/pages/game_page.dart';
import 'package:flutter/material.dart';

import '../get_it.dart';
import '../level/view/levels_cubit.dart';
import '../level/view/selected_level_cubit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    debugPrint(' HomePage init');
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenSize = mediaQueryData.size;
    final levelsWidth = -50.0 +
        ((mediaQueryData.orientation == Orientation.portrait)
            ? screenSize.width
            : screenSize.height);
    // debugPrint(' HomePage build');
    return BlocProvider(
      lazy: false,
      create: (_) => getIt<LevelsCubit>()..init(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Image.asset(
                  'assets/images/background/background2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShadowedText(
                  text: 'by Didier Boelens',
                  color: Colors.white,
                  fontSize: 12.0,
                  offset: Offset(1.0, 1.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  width: levelsWidth,
                  height: levelsWidth,
                  child: BlocBuilder<LevelsCubit, LevelsState>(
                      builder: (context, state) {
                        debugPrint('item builder ${state.levels}');
                    return GridView.builder(
                      itemCount: state.levels.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.01,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GameLevelButton(
                          width: 80.0,
                          height: 60.0,
                          borderRadius: 50.0,
                          text: 'Level ${index + 1}',
                          onTap: () async {
                            Level? newLevel = state.levels[index];

                            // Open the Game page
                            Navigator.of(context)
                                .push(GamePage.route(newLevel));
                          },
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              top: _animation.value * 250.0 - 150.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: DoubleCurvedContainer(
                  width: screenSize.width - 60.0,
                  height: 150.0,
                  outerColor: Colors.blue[700]!,
                  innerColor: Colors.blue,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: ShadowedText(
                          text: 'Flutter Crush',
                          color: Colors.white,
                          fontSize: 26.0,
                          shadowOpacity: 1.0,
                          offset: Offset(1.0, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
