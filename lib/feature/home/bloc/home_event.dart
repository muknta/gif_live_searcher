part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class InputEvent extends HomeEvent {
  const InputEvent(this.query);

  final String query;
}

class NextPageEvent extends HomeEvent {
  const NextPageEvent();
}

class HandledErrorEvent extends HomeEvent {
  const HandledErrorEvent();
}
