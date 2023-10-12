import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_live_searcher/feature/login/cubit/login_cubit.dart';
import 'package:gif_live_searcher/service/session_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SessionService>(),
  MockSpec<InternetConnectionChecker>(),
])
void main() {
  group('LoginCubit test', () {
    late LoginCubit cubit;
    late MockSessionService mockSessionService;
    late MockInternetConnectionChecker mockConnectionChecker;

    setUp(() {
      mockSessionService = MockSessionService();
      mockConnectionChecker = MockInternetConnectionChecker();
      cubit = LoginCubit(mockSessionService, mockConnectionChecker);

      when(mockSessionService.checkToken(apiToken: 'success')).thenAnswer((_) async => true);
      when(mockSessionService.checkToken(apiToken: 'failure')).thenAnswer((_) async => false);
      when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);
    });

    group('continue event', () {
      blocTest<LoginCubit, LoginState>(
        'Success',
        build: () => cubit,
        act: (cubit) => cubit.onContinue('success'),
        expect: () => [
          const LoginState.loading(),
          const LoginState.success(),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'unknown Failure',
        build: () => cubit,
        act: (cubit) => cubit.onContinue('failure'),
        expect: () => [
          const LoginState.loading(),
          const LoginState.failure(type: FailureType.wrongToken),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'internet Failure',
        build: () {
          when(mockConnectionChecker.hasConnection).thenAnswer((_) async => false);
          return cubit;
        },
        act: (cubit) => cubit.onContinue('failure'),
        expect: () => [
          const LoginState.loading(),
          const LoginState.failure(type: FailureType.noInternet),
        ],
      );
    });

    tearDown(() {
      cubit.close();
    });
  });
}
