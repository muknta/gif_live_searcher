import 'package:dio/dio.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'content_api.g.dart';

const paginationLimit = 30;
const isFake = false;

@RestApi()
@injectable
abstract class ContentApi {
  @factoryMethod
  factory ContentApi(Dio dio) => isFake ? FakeContentApi() : _ContentApi(dio);

  @GET('/gifs/search')
  Future<GifResponse> searchFor({
    @Query('q') required String query,
    @Query('limit') int limit = paginationLimit,
    @Query('offset') int offset = 0,
  });
}

class FakeContentApi implements ContentApi {
  @override
  Future<GifResponse> searchFor({
    required String query,
    int limit = paginationLimit,
    int offset = 0,
  }) {
    // TODO: implement searchFor
    throw UnimplementedError();
  }
}
