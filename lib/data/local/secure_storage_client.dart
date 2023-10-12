import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class SecureStorageClient {
  const SecureStorageClient({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const _giphyTokenKey = 'giphy-api-token';

  Future<void> writeGiphyApiToken(String apiToken) async => secureStorage.write(key: _giphyTokenKey, value: apiToken);

  Future<String?> readGiphyApiToken() async => secureStorage.read(key: _giphyTokenKey);

  Future<void> clearGiphyApiToken() async => secureStorage.delete(key: _giphyTokenKey);
}
