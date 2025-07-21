import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/face_analysis.dart';
import '../../domain/usecases/analyze_face.dart';
import '../../../../../../core/utils/image_compression_service.dart';
import '../../../../../../core/utils/api_debug_helper.dart';
import '../../data/datasources/face_analysis_remote_data_source.dart';

part 'analyze_face_event.dart';
part 'analyze_face_state.dart';

class AnalyzeFaceBloc extends Bloc<AnalyzeFaceEvent, AnalyzeFaceState> {
  final AnalyzeFace analyzeFaceUseCase;
  final FaceAnalysisRemoteDataSource remoteDataSource;

  AnalyzeFaceBloc({
    required this.analyzeFaceUseCase,
    required this.remoteDataSource,
  }) : super(AnalyzeFaceInitial()) {
    on<SelectFrontPhotoEvent>(_onSelectFrontPhoto);
    on<SelectProfilePhotoEvent>(_onSelectProfilePhoto);
    on<AnalyzeFaceStartEvent>(_onAnalyzeFaceStart);
    on<ResetAnalysisEvent>(_onResetAnalysis);
  }

  void _onSelectFrontPhoto(
    SelectFrontPhotoEvent event,
    Emitter<AnalyzeFaceState> emit,
  ) {
    final currentState = state;
    File? profilePhoto;

    if (currentState is AnalyzeFacePhotoSelected) {
      profilePhoto = currentState.profilePhoto;
    } else if (currentState is AnalyzeFaceError) {
      profilePhoto = currentState.profilePhoto;
    }

    emit(
      AnalyzeFacePhotoSelected(
        frontPhoto: event.photo,
        profilePhoto: profilePhoto,
      ),
    );
  }

  void _onSelectProfilePhoto(
    SelectProfilePhotoEvent event,
    Emitter<AnalyzeFaceState> emit,
  ) {
    final currentState = state;
    File? frontPhoto;

    if (currentState is AnalyzeFacePhotoSelected) {
      frontPhoto = currentState.frontPhoto;
    } else if (currentState is AnalyzeFaceError) {
      frontPhoto = currentState.frontPhoto;
    }

    emit(
      AnalyzeFacePhotoSelected(
        frontPhoto: frontPhoto,
        profilePhoto: event.photo,
      ),
    );
  }

  Future<void> _onAnalyzeFaceStart(
    AnalyzeFaceStartEvent event,
    Emitter<AnalyzeFaceState> emit,
  ) async {
    final currentState = state;

    if (currentState is AnalyzeFacePhotoSelected && currentState.canAnalyze) {
      emit(
        AnalyzeFaceLoading(
          frontPhoto: currentState.frontPhoto!,
          profilePhoto: currentState.profilePhoto!,
        ),
      );

      try {
        // 1. Primero probar conectividad
        final isConnected = await remoteDataSource.testConnectivity();
        if (!isConnected) {
          throw Exception(
            'No se pudo conectar al servidor. Verifica tu conexión a internet.',
          );
        }

        // 2. Comprimir imágenes de forma asíncrona para evitar congelamiento de UI
        File frontPhotoToSend;
        File profilePhotoToSend;

        try {


          final frontIsValid = await ApiDebugHelper.isValidImageFile(
            currentState.frontPhoto!,
          );
          final profileIsValid = await ApiDebugHelper.isValidImageFile(
            currentState.profilePhoto!,
          );

          if (!frontIsValid || !profileIsValid) {
            throw Exception(
              'Una o ambas imágenes no son válidas para el análisis',
            );
          }

          frontPhotoToSend =
              await ImageCompressionService.compressImageForAnalysis(
                currentState.frontPhoto!,
              );

          profilePhotoToSend =
              await ImageCompressionService.compressImageForAnalysis(
                currentState.profilePhoto!,
              );


        } catch (compressionError) {
          // Si falla la compresión, usar imágenes originales
          frontPhotoToSend = currentState.frontPhoto!;
          profilePhotoToSend = currentState.profilePhoto!;
        }

        // 3. Hacer el análisis
        final faceAnalysis = await analyzeFaceUseCase(
          AnalyzeFaceParams(
            frontPhoto: frontPhotoToSend,
            profilePhoto: profilePhotoToSend,
          ),
        );

        emit(AnalyzeFaceSuccess(faceAnalysis));
      } catch (e) {
        emit(
          AnalyzeFaceError(
            message: e.toString(),
            frontPhoto: currentState.frontPhoto,
            profilePhoto: currentState.profilePhoto,
          ),
        );
      }
    }
  }

  void _onResetAnalysis(
    ResetAnalysisEvent event,
    Emitter<AnalyzeFaceState> emit,
  ) {
    emit(AnalyzeFaceInitial());
  }
}
