import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_appointment_bloc.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String businessId;

  const ErrorView({super.key, required this.message, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CreateAppointmentBloc>().add(
                LoadBusinessServices(businessId),
              );
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
