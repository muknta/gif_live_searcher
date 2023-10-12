import 'package:flutter/material.dart';
import 'package:gif_live_searcher/feature/feature.dart';
import 'package:gif_live_searcher/service/session_service.dart';
import 'package:gif_live_searcher/utils/locator.dart';
import 'package:gif_live_searcher/utils/theme_utils.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<bool>(
        stream: getIt<SessionService>().onSession,
        builder: (context, onSessionSnap) {
          if (onSessionSnap.hasData) {
            if (onSessionSnap.data!) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }
          return const LoadingPage();
        },
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
