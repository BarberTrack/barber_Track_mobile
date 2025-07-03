import 'package:flutter/material.dart';
import '../../../../../../features/appointments/features/appoinments_home/domain/entities/appointment.dart';
import 'create_review_modal.dart';

class CreateReviewButton extends StatelessWidget {
  final Appointment appointment;

  const CreateReviewButton({Key? key, required this.appointment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostrar el botón si el status es "completed"
    if (appointment.status != 'completed') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                CreateReviewModal(appointmentId: appointment.id),
          );
        },
        icon: const Icon(Icons.star_rate, color: Colors.white),
        label: const Text(
          'Crear Reseña',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[600],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
