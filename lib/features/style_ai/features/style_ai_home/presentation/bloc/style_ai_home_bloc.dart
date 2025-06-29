import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/style_history.dart';
import '../../domain/usecases/get_style_history.dart';

part 'style_ai_home_event.dart';
part 'style_ai_home_state.dart';

class StyleAiHomeBloc extends Bloc<StyleAiHomeEvent, StyleAiHomeState> {
  final GetStyleHistory getStyleHistory;

  StyleAiHomeBloc({required this.getStyleHistory})
    : super(StyleAiHomeInitial()) {
    on<LoadStyleHistoryEvent>(_onLoadStyleHistory);
  }

  Future<void> _onLoadStyleHistory(
    LoadStyleHistoryEvent event,
    Emitter<StyleAiHomeState> emit,
  ) async {
    emit(StyleAiHomeLoading());

    try {
      final styleHistory = await getStyleHistory();

      if (styleHistory.analyses.isEmpty) {
        emit(StyleAiHomeEmpty());
      } else {
        emit(StyleAiHomeSuccess(styleHistory));
      }
    } catch (e) {
      emit(StyleAiHomeError(e.toString()));
    }
  }
}
