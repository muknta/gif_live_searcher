part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.init() = _Init;

  const factory LoginState.loading() = _Loading;

  const factory LoginState.failure({
    required FailureType type,
  }) = _Failure;

  const factory LoginState.success() = _Success;
}

enum FailureType {
  noInternet,
  wrongToken,
}
