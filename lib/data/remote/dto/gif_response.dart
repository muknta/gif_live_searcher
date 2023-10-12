import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_data.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_meta.dart';

part 'gif_response.g.dart';

@JsonSerializable()
class GifResponse {
  const GifResponse({required this.data, required this.meta, required this.pagination});

  final List<GifData> data;
  final GifMeta meta;
  final GifPagination pagination;

  factory GifResponse.fromJson(Map<String, dynamic> json) => _$GifResponseFromJson(json);
}

@JsonSerializable()
class GifPagination {
  const GifPagination({required this.offset, required this.totalCount, required this.count});

  final int offset;
  @JsonKey(name: 'total_count')
  final int totalCount;
  final int count;

  factory GifPagination.fromJson(Map<String, dynamic> json) => _$GifPaginationFromJson(json);
}
