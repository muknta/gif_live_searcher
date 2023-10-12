import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_live_searcher/data/remote/content_api.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_data.dart';
import 'package:gif_live_searcher/service/searcher_service.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

part 'home_bloc.freezed.dart';
part 'home_state.dart';
part 'home_event.dart';

@injectable
class HomeCubit extends Bloc<HomeEvent, HomeState> {
  HomeCubit(this._searcherService) : super(const HomeState.input(query: '', gifs: <GifData>[], offset: 0)) {
    on<InputEvent>(
      (event, emit) async {
        try {
          final response = await _searcherService.searchFor(
            query: event.query,
            offset: state.offset,
          );
          emit(HomeState.input(query: event.query, gifs: response.data, offset: response.pagination.offset));
        } catch (_) {
          await _emitError(emit);
        }
      },
      transformer: (events, mapper) {
        return events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper);
      },
    );

    on<NextPageEvent>(
      (event, emit) async {
        if (state.maybeMap(paginationLoading: (_) => true, orElse: () => false)) {
          return;
        }
        emit(HomeState.paginationLoading(query: state.query, gifs: state.gifs, offset: state.offset));
        try {
          final response = await _searcherService.searchFor(
            query: state.query,
            offset: state.offset + paginationLimit,
          );
          emit(HomeState.input(
            query: state.query,
            gifs: state.gifs.toList()..addAll(response.data),
            offset: response.pagination.offset,
          ));
        } catch (_) {
          await _emitError(emit);
        }
      },
    );

    on<HandledErrorEvent>(
      (event, emit) async {
        state.maybeMap(
          requestFailure: (state) => emit(HomeState.input(query: state.query, gifs: state.gifs, offset: state.offset)),
          orElse: () => null,
        );
      },
    );
  }

  final SearcherService _searcherService;

  Future<void> _emitError(Emitter<HomeState> emit) async {
    if (!await InternetConnectionChecker().hasConnection) {
      emit(HomeState.requestFailure(
          type: FailureType.noInternet, query: state.query, gifs: state.gifs, offset: state.offset));
    } else {
      emit(HomeState.requestFailure(
          type: FailureType.unknown, query: state.query, gifs: state.gifs, offset: state.offset));
    }
  }
}
