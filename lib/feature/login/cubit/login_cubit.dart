import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_live_searcher/service/session_service.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._sessionService) : super(const LoginState.init());

  final SessionService _sessionService;

  void onContinue(String apiToken) async {
    final token = apiToken.trim();
    if (token.isEmpty) {
      return;
    }
    emit(const LoginState.loading());
    try {
      final isOk = await _sessionService.checkToken(apiToken: token);
      if (isOk) {
        await _sessionService.registerSession(apiToken: apiToken);
        emit(const LoginState.success());
      } else {
        await emitError();
      }
    } catch (_) {
      await emitError();
    }
  }

  Future<void> emitError() async {
    if (!await InternetConnectionChecker().hasConnection) {
      emit(const LoginState.failure(type: FailureType.noInternet));
    } else {
      emit(const LoginState.failure(type: FailureType.wrongToken));
    }
  }
}
