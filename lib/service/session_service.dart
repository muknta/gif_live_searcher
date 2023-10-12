import 'package:dio/dio.dart';
import 'package:gif_live_searcher/data/local/secure_storage_client.dart';
import 'package:gif_live_searcher/data/remote/session_api.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class SessionService {
  SessionService({required SecureStorageClient storageClient, required SessionApi sessionApi})
      : _storageClient = storageClient,
        _sessionApi = sessionApi;

  final SecureStorageClient _storageClient;
  final SessionApi _sessionApi;

  String? _apiToken;

  String? get apiToken => _apiToken;

  late final _onSession = BehaviorSubject<bool>();
  BehaviorSubject<bool> get onSession => _onSession;

  /// Returns `success or not`
  Future<bool> checkToken({required String apiToken}) async {
    try {
      final response = await _sessionApi.checkApiToken(apiToken);
      final status = response.meta.status;
      return status >= 200 && status < 300;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      return status != null && status >= 200 && status < 300;
    }
  }

  Future<void> initSession() async {
    _apiToken = await _storageClient.readGiphyApiToken();
    _onSession.add(_apiToken != null);
  }

  Future<void> registerSession({
    required String apiToken,
  }) async {
    await _storageClient.writeGiphyApiToken(apiToken);
    _apiToken = apiToken;
    _onSession.add(true);
  }

  Future<void> closeSession() async {
    if (_apiToken != null) {
      _apiToken = null;
      await _storageClient.clearGiphyApiToken();
    }
    _onSession.add(false);
  }
}
