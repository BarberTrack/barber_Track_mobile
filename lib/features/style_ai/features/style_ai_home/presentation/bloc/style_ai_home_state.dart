part of 'style_ai_home_bloc.dart';

abstract class StyleAiHomeState extends Equatable {
  const StyleAiHomeState();

  @override
  List<Object> get props => [];
}

class StyleAiHomeInitial extends StyleAiHomeState {}

class StyleAiHomeLoading extends StyleAiHomeState {}

class StyleAiHomeSuccess extends StyleAiHomeState {
  final StyleHistory styleHistory;

  const StyleAiHomeSuccess(this.styleHistory);

  @override
  List<Object> get props => [styleHistory];
}

class StyleAiHomeEmpty extends StyleAiHomeState {}

class StyleAiHomeError extends StyleAiHomeState {
  final String message;

  const StyleAiHomeError(this.message);

  @override
  List<Object> get props => [message];
}
