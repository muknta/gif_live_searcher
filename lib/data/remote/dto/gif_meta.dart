import 'package:freezed_annotation/freezed_annotation.dart';

part 'gif_meta.g.dart';

@JsonSerializable()
class GifMeta {
  const GifMeta({required this.msg, required this.status});

  final String msg;
  final int status;

  factory GifMeta.fromJson(Map<String, dynamic> json) => _$GifMetaFromJson(json);
}
