import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_meta.dart';

part 'random_id_response.g.dart';

@JsonSerializable()
class RandomIdResponse {
  const RandomIdResponse({required this.data, required this.meta});

  final RandomIdData data;
  final GifMeta meta;

  factory RandomIdResponse.fromJson(Map<String, dynamic> json) => _$RandomIdResponseFromJson(json);
}

@JsonSerializable()
class RandomIdData {
  const RandomIdData({required this.randomId});

  @JsonKey(name: 'random_id')
  final String randomId;

  factory RandomIdData.fromJson(Map<String, dynamic> json) => _$RandomIdDataFromJson(json);
}
