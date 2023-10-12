import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gif_live_searcher/data/remote/interceptor/auth_interceptor.dart';
import 'package:gif_live_searcher/utils/network_manager.dart';
import 'package:injectable/injectable.dart';

/// This module should NOT be used manually.
/// The only idea of this class is singleton getters for Injectable
@module
abstract class ThirdPartyModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          // https://github.com/mogol/flutter_secure_storage/issues/354
          encryptedSharedPreferences: true,
        ),
      );

  @Named(NetworkManager.noAuthDioName)
  Dio noAuthDio() => NetworkManager.getDio();

  Dio authDio(AuthInterceptor authInterceptor) => NetworkManager.getDio(
        interceptors: [authInterceptor],
      );
}
