import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/analyze_face_bloc.dart';
import '../widgets/photo_selector_widget.dart';
import '../widgets/analysis_results_widget.dart';

class AnalyzeFacePage extends StatelessWidget {
  const AnalyzeFacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnalyzeFaceBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Análisis Facial',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            BlocBuilder<AnalyzeFaceBloc, AnalyzeFaceState>(
              builder: (context, state) {
                if (state is AnalyzeFaceSuccess ||
                    (state is AnalyzeFaceError &&
                        (state.frontPhoto != null ||
                            state.profilePhoto != null))) {
                  return IconButton(
                    onPressed: () {
                      context.read<AnalyzeFaceBloc>().add(
                        const ResetAnalysisEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Nuevo análisis',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent.withOpacity(0.1),
                Colors.blue.withOpacity(0.05),
              ],
            ),
          ),
          child: BlocBuilder<AnalyzeFaceBloc, AnalyzeFaceState>(
            builder: (context, state) {
              if (state is AnalyzeFaceSuccess) {
                return AnalysisResultsWidget(faceAnalysis: state.faceAnalysis);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildPhotoSelectors(context, state),
                    const SizedBox(height: 32),
                    _buildAnalyzeButton(context, state),
                    if (state is AnalyzeFaceError) ...[
                      const SizedBox(height: 20),
                      _buildErrorMessage(state.message),
                    ],
                    if (state is AnalyzeFaceLoading) ...[
                      const SizedBox(height: 40),
                      _buildLoadingIndicator(),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.face_retouching_natural,
            size: 60,
            color: Colors.blueAccent.shade400,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Análisis Facial con IA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sube dos fotos para obtener recomendaciones de estilo personalizadas',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSelectors(BuildContext context, AnalyzeFaceState state) {
    File? frontPhoto;
    File? profilePhoto;

    if (state is AnalyzeFacePhotoSelected) {
      frontPhoto = state.frontPhoto;
      profilePhoto = state.profilePhoto;
    } else if (state is AnalyzeFaceLoading) {
      frontPhoto = state.frontPhoto;
      profilePhoto = state.profilePhoto;
    } else if (state is AnalyzeFaceError) {
      frontPhoto = state.frontPhoto;
      profilePhoto = state.profilePhoto;
    }

    return Column(
      children: [
        PhotoSelectorWidget(
          title: 'Foto Frontal',
          subtitle: 'Sube una foto de frente con buena iluminación',
          selectedPhoto: frontPhoto,
          onPhotoSelected: (photo) {
            context.read<AnalyzeFaceBloc>().add(SelectFrontPhotoEvent(photo));
          },
          icon: Icons.face,
        ),
        const SizedBox(height: 20),
        PhotoSelectorWidget(
          title: 'Foto de Perfil',
          subtitle: 'Sube una foto de perfil lateral',
          selectedPhoto: profilePhoto,
          onPhotoSelected: (photo) {
            context.read<AnalyzeFaceBloc>().add(SelectProfilePhotoEvent(photo));
          },
          icon: Icons.face_retouching_natural,
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton(BuildContext context, AnalyzeFaceState state) {
    bool canAnalyze = false;
    bool isLoading = false;

    if (state is AnalyzeFacePhotoSelected) {
      canAnalyze = state.canAnalyze;
    } else if (state is AnalyzeFaceLoading) {
      isLoading = true;
    }

    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canAnalyze && !isLoading
            ? () {
                context.read<AnalyzeFaceBloc>().add(
                  const AnalyzeFaceStartEvent(),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_fix_high,
                    size: 24,
                    color: canAnalyze ? Colors.white : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Analizar por IA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: canAnalyze ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          Text(
            'Procesando imágenes...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Optimizando y analizando tu rostro con IA',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          Text(
            'No cierres la aplicación durante el análisis',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
