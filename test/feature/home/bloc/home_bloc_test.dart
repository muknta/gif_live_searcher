import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_meta.dart';
import 'package:gif_live_searcher/data/remote/dto/gif_response.dart';
import 'package:gif_live_searcher/feature/home/bloc/home_bloc.dart';
import 'package:gif_live_searcher/service/searcher_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearcherService>(),
  MockSpec<InternetConnectionChecker>(),
])
void main() {
  group('HomeBloc test', () {
    late MockSearcherService mockSearcherService;
    late MockInternetConnectionChecker mockConnectionChecker;
    late HomeBloc bloc;

    setUp(() {
      mockSearcherService = MockSearcherService();
      mockConnectionChecker = MockInternetConnectionChecker();
      bloc = HomeBloc(mockSearcherService, mockConnectionChecker);

      when(mockSearcherService.searchFor(query: 'success')).thenAnswer((_) async => const GifResponse(
            data: [],
            meta: GifMeta(msg: '', status: 200),
            pagination: GifPagination(offset: 0, totalCount: 0, count: 0),
          ));
      when(mockSearcherService.searchFor(query: 'failure')).thenAnswer((_) async => const GifResponse(
            data: [],
            meta: GifMeta(msg: '', status: 403),
            pagination: GifPagination(offset: 0, totalCount: 0, count: 0),
          ));
      when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);
    });

    group('input event', () {
      blocTest<HomeBloc, HomeState>(
        'Success',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InputEvent('success'));
          await Future.delayed(const Duration(milliseconds: debounceMillisec));
        },
        expect: () => [
          const HomeState.input(query: 'success', gifs: [], offset: 0),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'unknown Failure',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InputEvent('failure'));
          await Future.delayed(const Duration(milliseconds: debounceMillisec));
        },
        expect: () => [
          const HomeState.requestFailure(type: FailureType.unknown, query: 'failure', gifs: [], offset: 0),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'internet Failure',
        build: () {
          when(mockConnectionChecker.hasConnection).thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const InputEvent('failure'));
          await Future.delayed(const Duration(milliseconds: debounceMillisec));
        },
        expect: () => [
          const HomeState.requestFailure(type: FailureType.noInternet, query: 'failure', gifs: [], offset: 0),
        ],
      );
    });

    tearDown(() {
      bloc.close();
    });
  });
}
