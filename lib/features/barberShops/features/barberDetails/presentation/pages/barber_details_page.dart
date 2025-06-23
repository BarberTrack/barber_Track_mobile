import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../bloc/barberdetails_bloc.dart';
import '../../../../../appointments/features/create_appointment/presentation/pages/create_appointment_page.dart';

class BarberDetailsPage extends StatelessWidget {
  final String businessId;

  const BarberDetailsPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BarberdetailsBloc>()..add(LoadBusinessDetails(businessId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detalles de barbería"),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
          builder: (context, state) {
            if (state is BarberdetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BarberdetailsLoaded) {
              return _buildBusinessDetails(state.business);
            } else if (state is BarberdetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BarberdetailsBloc>().add(
                          LoadBusinessDetails(businessId),
                        );
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Estado inicial'));
          },
        ),
        floatingActionButton: BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
          builder: (context, state) {
            // Solo mostrar el botón si los datos se cargaron exitosamente
            if (state is BarberdetailsLoaded) {
              return FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateAppointmentPage(businessId: businessId),
                    ),
                  );
                },
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  'Agendar cita',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            }
            return const SizedBox.shrink(); // No mostrar nada si no hay datos cargados
          },
        ),
      ),
    );
  }

  Widget _buildBusinessDetails(dynamic business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del negocio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Nombre',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(business.name, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Descripción
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dirección
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Dirección',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(business.address, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Teléfono
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Teléfono',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(business.phone, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Horas de negocio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Horas de negocio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBusinessHours(business.businessHours),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHours(Map<String, dynamic> businessHours) {
    final days = [
      {'key': 'monday', 'name': 'Lunes'},
      {'key': 'tuesday', 'name': 'Martes'},
      {'key': 'wednesday', 'name': 'Miércoles'},
      {'key': 'thursday', 'name': 'Jueves'},
      {'key': 'friday', 'name': 'Viernes'},
      {'key': 'saturday', 'name': 'Sábado'},
      {'key': 'sunday', 'name': 'Domingo'},
    ];

    return Column(
      children: days.map((day) {
        final dayData = businessHours[day['key']] as Map<String, dynamic>?;
        final isClosed = dayData?['closed'] == true;
        final openTime = dayData?['open'] as String?;
        final closeTime = dayData?['close'] as String?;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day['name']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isClosed
                    ? 'Cerrado'
                    : (openTime != null && closeTime != null)
                    ? '$openTime - $closeTime'
                    : 'No disponible',
                style: TextStyle(
                  fontSize: 14,
                  color: isClosed ? Colors.red.shade600 : Colors.green.shade600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
