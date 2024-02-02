import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_widgets/double_curved_container.dart';
import '../game_widgets/game_level_button.dart';
import '../game_widgets/shadowed_text.dart';
import '../get_it.dart';
import '../level/view/levels_cubit.dart';
import '../model/level.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
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
        curve: const Interval(
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
            const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ShadowedText(
                  text: 'by Didier Boelens',
                  fontSize: 12.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: SizedBox(
                  width: levelsWidth,
                  height: levelsWidth,
                  child: BlocBuilder<LevelsCubit, LevelsState>(
                      builder: (context, state) {
                        debugPrint('item builder ${state.levels}');
                    return GridView.builder(
                      itemCount: state.levels.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.01,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GameLevelButton(
                          width: 80.0,
                          text: 'Level ${index + 1}',
                          onTap: () async {
                            final Level newLevel = state.levels[index];

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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: DoubleCurvedContainer(
                  width: screenSize.width - 60.0,
                  height: 150.0,
                  outerColor: Colors.blue[700]!,
                  innerColor: Colors.blue,
                  child: const Stack(
                    children: <Widget>[
                      Align(
                        child: ShadowedText(
                          text: 'Flutter Crush',
                          fontSize: 26.0,
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
