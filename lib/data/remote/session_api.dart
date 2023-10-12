import 'package:dio/dio.dart';
import 'package:gif_live_searcher/data/remote/dto/random_id_response.dart';
import 'package:gif_live_searcher/utils/network_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'session_api.g.dart';

const isFake = false;

@RestApi()
@injectable
abstract class SessionApi {
  @factoryMethod
  factory SessionApi(@Named(NetworkManager.noAuthDioName) Dio dio) => isFake ? FakeSessionApi() : _SessionApi(dio);

  /// Returns random id
  @GET('/randomid')
  Future<RandomIdResponse> checkApiToken(@Query('api_key') String apiToken);
}

class FakeSessionApi implements SessionApi {
  @override
  Future<RandomIdResponse> checkApiToken(String apiToken) {
    // TODO: implement getRandomId
    throw UnimplementedError();
  }
}
