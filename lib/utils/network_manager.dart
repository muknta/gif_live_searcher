import 'package:dio/dio.dart';

class NetworkManager {
  static const noAuthDioName = 'no-auth';

  static Dio getDio({List<Interceptor> interceptors = const []}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.giphy.com/v1',
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
      ),
    );
    dio.interceptors.addAll(interceptors);
    return dio;
  }

  static String combineGifUrl(String gifId) {
    // TODO: load image with original size for Full-Screen view
    return 'https://media.giphy.com/media/$gifId/200_d.gif';
  }
}
