import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gif_live_searcher/service/session_service.dart';
import 'package:gif_live_searcher/utils/locator.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  const AuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = getIt<SessionService>().apiToken;
    if (accessToken != null) {
      options.queryParameters['api_key'] = accessToken;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: LoggerInterceptor
    debugPrint('error $err');
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      getIt<SessionService>().closeSession();
    }
    return super.onError(err, handler);
  }
}
