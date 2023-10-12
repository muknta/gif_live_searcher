import 'package:gif_live_searcher/data/remote/content_api.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_response.dart';
import 'package:injectable/injectable.dart';

@singleton
class SearcherService {
  SearcherService({required ContentApi contentApi}) : _contentApi = contentApi;

  final ContentApi _contentApi;

  Future<GifResponse> searchFor({
    required String query,
    int limit = paginationLimit,
    int offset = 0,
  }) async {
    return _contentApi.searchFor(
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
