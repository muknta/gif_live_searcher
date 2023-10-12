import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> setupLocators(String environment) async => getIt.init();
