import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/router/app_router.dart';
import '../bloc/create_appointment_bloc.dart';
import '../../domain/entities/service.dart';

class ServicesView extends StatelessWidget {
  final CreateAppointmentServicesLoaded state;

  const ServicesView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Si no hay servicios disponibles
    if (state.services.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.work_off,
                  size: 48,
                  color: Colors.orange.shade300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No hay servicios',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade300,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Esta barbería no tiene servicios disponibles en este momento.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.go(AppRouter.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                ),
                icon: const Icon(Icons.home),
                label: Text(
                  'Ir a Inicio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona un servicio:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return _ServiceCard(service: service);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(service.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description),
            const SizedBox(height: 4),
            Text(
              '\$${service.price.toStringAsFixed(2)} - ${service.durationMinutes} min',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.read<CreateAppointmentBloc>().add(SelectService(service));
        },
      ),
    );
  }
}
