import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'style_ai_home_event.dart';
part 'style_ai_home_state.dart';

class StyleAiHomeBloc extends Bloc<StyleAiHomeEvent, StyleAiHomeState> {
  StyleAiHomeBloc() : super(StyleAiHomeInitial()) {
    on<StyleAiHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
