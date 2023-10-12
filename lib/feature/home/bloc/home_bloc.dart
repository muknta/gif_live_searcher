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

const debounceMillisec = 300;

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._searcherService, this._connectionChecker)
      : super(const HomeState.input(query: '', gifs: <GifData>[], offset: 0)) {
    on<InputEvent>(
      (event, emit) async {
        try {
          final response = await _searcherService.searchFor(
            query: event.query,
            offset: state.offset,
          );
          if (response.meta.status >= 200 && response.meta.status < 300) {
            emit(HomeState.input(query: event.query, gifs: response.data, offset: response.pagination.offset));
          } else {
            await _emitError(emit, event.query);
          }
        } catch (_) {
          await _emitError(emit, event.query);
        }
      },
      transformer: (events, mapper) {
        return events.debounceTime(const Duration(milliseconds: debounceMillisec)).asyncExpand(mapper);
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
          if (response.meta.status >= 200 && response.meta.status < 300) {
            emit(HomeState.input(
              query: state.query,
              gifs: state.gifs.toList()..addAll(response.data),
              offset: response.pagination.offset,
            ));
          } else {
            await _emitError(emit, state.query);
          }
        } catch (_) {
          await _emitError(emit, state.query);
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
  final InternetConnectionChecker _connectionChecker;

  Future<void> _emitError(Emitter<HomeState> emit, String query) async {
    if (!await _connectionChecker.hasConnection) {
      emit(
          HomeState.requestFailure(type: FailureType.noInternet, query: query, gifs: state.gifs, offset: state.offset));
    } else {
      emit(HomeState.requestFailure(type: FailureType.unknown, query: query, gifs: state.gifs, offset: state.offset));
    }
  }
}
