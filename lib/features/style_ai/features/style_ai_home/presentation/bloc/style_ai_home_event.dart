part of 'style_ai_home_bloc.dart';

abstract class StyleAiHomeEvent extends Equatable {
  const StyleAiHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadStyleHistoryEvent extends StyleAiHomeEvent {
  const LoadStyleHistoryEvent();
}
