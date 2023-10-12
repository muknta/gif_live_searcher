part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.input({
    required String query,
    required List<GifData> gifs,
    required int offset,
  }) = _Input;

  const factory HomeState.requestFailure({
    required FailureType type,
    required String query,
    required List<GifData> gifs,
    required int offset,
  }) = _RequestFailure;

  const factory HomeState.paginationLoading({
    required String query,
    required List<GifData> gifs,
    required int offset,
  }) = _PaginationLoading;
}

enum FailureType {
  noInternet,
  unknown,
}
