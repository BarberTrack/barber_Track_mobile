import 'package:bloc/bloc.dart';
import '../../domain/usecases/analyze_reference_image.dart';
import 'analyze_reference_event.dart';
import 'analyze_reference_state.dart';

class AnalyzeReferenceBloc
    extends Bloc<AnalyzeReferenceEvent, AnalyzeReferenceState> {
  final AnalyzeReferenceImage analyzeReferenceImageUseCase;

  AnalyzeReferenceBloc({required this.analyzeReferenceImageUseCase})
    : super(AnalyzeReferenceInitial()) {
    on<AnalyzeReferenceImageEvent>(_onAnalyzeReferenceImage);
    on<ResetAnalyzeReferenceEvent>(_onResetAnalyzeReference);
  }

  Future<void> _onAnalyzeReferenceImage(
    AnalyzeReferenceImageEvent event,
    Emitter<AnalyzeReferenceState> emit,
  ) async {
    emit(AnalyzeReferenceLoading());

    try {
      final styleAnalysis = await analyzeReferenceImageUseCase.call(
        event.referenceImage,
      );
      emit(AnalyzeReferenceSuccess(styleAnalysis));
    } catch (e) {
      emit(AnalyzeReferenceError(e.toString()));
    }
  }

  void _onResetAnalyzeReference(
    ResetAnalyzeReferenceEvent event,
    Emitter<AnalyzeReferenceState> emit,
  ) {
    emit(AnalyzeReferenceInitial());
  }
}
