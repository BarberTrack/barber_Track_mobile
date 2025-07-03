import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/create_review_bloc.dart';
import '../bloc/create_review_event.dart';
import '../bloc/create_review_state.dart';

class CreateReviewModal extends StatefulWidget {
  final String appointmentId;

  const CreateReviewModal({Key? key, required this.appointmentId})
    : super(key: key);

  @override
  State<CreateReviewModal> createState() => _CreateReviewModalState();
}

class _CreateReviewModalState extends State<CreateReviewModal> {
  int businessRating = 5;
  int barberRating = 5;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateReviewBloc>(),
      child: BlocListener<CreateReviewBloc, CreateReviewState>(
        listener: (context, state) {
          if (state is CreateReviewSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reseña creada correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CreateReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.contains('Ya hay una reseña')
                      ? 'Ya hay una reseña para esta cita'
                      : 'Error al crear la reseña',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Crear Reseña',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Calificación del negocio
                const Text(
                  'Calificación del Negocio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          businessRating = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 32,
                        color: index < businessRating
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Calificación del barbero
                const Text(
                  'Calificación del Barbero',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          barberRating = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 32,
                        color: index < barberRating
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Comentario
                const Text(
                  'Comentario (Opcional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu comentario aquí...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocBuilder<CreateReviewBloc, CreateReviewState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is CreateReviewLoading
                                ? null
                                : () {
                                    context.read<CreateReviewBloc>().add(
                                      SubmitReviewEvent(
                                        appointmentId: widget.appointmentId,
                                        businessRating: businessRating,
                                        barberRating: barberRating,
                                        comment:
                                            commentController.text
                                                .trim()
                                                .isEmpty
                                            ? ''
                                            : commentController.text.trim(),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is CreateReviewLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Crear Reseña'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
