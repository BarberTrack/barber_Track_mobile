import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';

class ServiceSummary extends StatelessWidget {
  final Service service;
  final String businessId;

  const ServiceSummary({
    super.key,
    required this.service,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Servicio seleccionado',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.read<CreateAppointmentBloc>().add(
                      LoadBusinessServices(businessId),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.blue.shade600,
                  ),
                  label: Text(
                    'Cambiar servicio',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(service.name, style: const TextStyle(fontSize: 18)),
            Text(
              '\$${service.price.toStringAsFixed(2)} - ${service.durationMinutes} min',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
