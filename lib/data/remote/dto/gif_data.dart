import 'package:freezed_annotation/freezed_annotation.dart';

part 'gif_data.g.dart';

@JsonSerializable()
class GifData {
  const GifData({required this.id, required this.altText});

  final String id;
  @JsonKey(name: 'alt_text')
  final String? altText;

  factory GifData.fromJson(Map<String, dynamic> json) => _$GifDataFromJson(json);
}
