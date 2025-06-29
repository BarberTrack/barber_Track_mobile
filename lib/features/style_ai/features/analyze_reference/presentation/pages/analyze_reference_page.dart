import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/analyze_reference_bloc.dart';
import '../bloc/analyze_reference_event.dart';
import '../bloc/analyze_reference_state.dart';
import '../widgets/analysis_result_widget.dart';
import '../widgets/image_selection_widget.dart';

class AnalyzeReferencePage extends StatefulWidget {
  const AnalyzeReferencePage({super.key});

  @override
  State<AnalyzeReferencePage> createState() => _AnalyzeReferencePageState();
}

class _AnalyzeReferencePageState extends State<AnalyzeReferencePage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _selectImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 1920,
        maxWidth: 1080,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al seleccionar imagen: $e');
    }
  }

  void _analyzeImage(BuildContext blocContext) {
    if (_selectedImage != null) {
      blocContext.read<AnalyzeReferenceBloc>().add(
        AnalyzeReferenceImageEvent(_selectedImage!),
      );
    }
  }

  void _resetAnalysis(BuildContext blocContext) {
    setState(() {
      _selectedImage = null;
    });
    blocContext.read<AnalyzeReferenceBloc>().add(ResetAnalyzeReferenceEvent());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnalyzeReferenceBloc>(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Análisis de Referencia',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocConsumer<AnalyzeReferenceBloc, AnalyzeReferenceState>(
          listener: (context, state) {
            if (state is AnalyzeReferenceError) {
              _showErrorSnackBar(state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  ImageSelectionWidget(
                    selectedImage: _selectedImage,
                    onSelectImage: _selectImageFromGallery,
                  ),
                  const SizedBox(height: 24),
                  _buildAnalyzeButton(state, context),
                  const SizedBox(height: 24),
                  if (state is AnalyzeReferenceLoading) _buildLoadingWidget(),
                  if (state is AnalyzeReferenceSuccess)
                    AnalysisResultWidget(
                      styleAnalysis: state.styleAnalysis,
                      onReset: () => _resetAnalysis(context),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Análisis de Estilo con IA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Sube una imagen de referencia y obtén una descripción detallada del estilo de cabello',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFE5E7EB),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton(
    AnalyzeReferenceState state,
    BuildContext blocContext,
  ) {
    final isLoading = state is AnalyzeReferenceLoading;
    final canAnalyze = _selectedImage != null && !isLoading;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: canAnalyze
            ? const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
              )
            : null,
        color: canAnalyze ? null : const Color(0xFF374151),
        boxShadow: canAnalyze
            ? [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canAnalyze ? () => _analyzeImage(blocContext) : null,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: canAnalyze
                            ? Colors.white
                            : const Color(0xFF9CA3AF),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Analizar Estilo',
                        style: TextStyle(
                          color: canAnalyze
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF60A5FA),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Analizando imagen...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nuestro IA está procesando tu imagen de referencia',
            style: TextStyle(fontSize: 14, color: Color(0xFFE5E7EB)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
