import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/create_review_modal.dart';

class CreateReviewPage extends StatelessWidget {
  final String appointmentId;

  const CreateReviewPage({Key? key, required this.appointmentId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Reseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateReviewModal(appointmentId: appointmentId),
      ),
    );
  }
}
