import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif_live_searcher/application.dart';
import 'package:gif_live_searcher/service/session_service.dart';
import 'package:gif_live_searcher/utils/locator.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocators(kDebugMode ? Environment.dev : Environment.prod);
  await getIt<SessionService>().initSession();

  runApp(const Application());
}
