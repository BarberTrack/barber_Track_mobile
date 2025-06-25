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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: Text(
            "Detalles de barbería",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.blueAccent.withOpacity(0.3),
        ),
        body: BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
          builder: (context, state) {
            if (state is BarberdetailsLoading) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blueAccent,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando detalles...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BarberdetailsLoaded) {
              return _buildBusinessDetails(state.business);
            } else if (state is BarberdetailsError) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
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
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Error al cargar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade300,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BarberdetailsBloc>().add(
                            LoadBusinessDetails(businessId),
                          );
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
                        child: Text(
                          'Reintentar',
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
            return Center(
              child: Text(
                'Estado inicial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                  letterSpacing: 0.5,
                ),
              ),
            );
          },
        ),
        floatingActionButton:
            BlocBuilder<BarberdetailsBloc, BarberdetailsState>(
              builder: (context, state) {
                if (state is BarberdetailsLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: FloatingActionButton.extended(
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
                      icon: const Icon(Icons.calendar_today, size: 20),
                      label: Text(
                        'Agendar cita',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }

  Widget _buildBusinessDetails(dynamic business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del negocio
          _buildDetailCard(
            icon: Icons.store,
            title: 'Nombre',
            content: business.name,
            iconColor: Colors.blueAccent,
          ),
          const SizedBox(height: 20),

          // Descripción
          _buildDetailCard(
            icon: Icons.description,
            title: 'Descripción',
            content: business.description,
            iconColor: Colors.blueAccent,
          ),
          const SizedBox(height: 20),

          // Dirección
          _buildDetailCard(
            icon: Icons.location_on,
            title: 'Dirección',
            content: business.address,
            iconColor: Colors.red.shade400,
          ),
          const SizedBox(height: 20),

          // Teléfono
          _buildDetailCard(
            icon: Icons.phone,
            title: 'Teléfono',
            content: business.phone,
            iconColor: Colors.green.shade400,
          ),
          const SizedBox(height: 20),

          // Horas de negocio
          Card(
            elevation: 8,
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade900,
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade900,
                    Colors.grey.shade800.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.orange.shade300,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Horas de negocio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBusinessHours(business.businessHours),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100), // Espacio extra para el FAB
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade300,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
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

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isClosed
                ? Colors.red.withOpacity(0.2)
                : Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isClosed
                  ? Colors.red.withOpacity(0.4)
                  : Colors.green.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day['name']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isClosed
                      ? Colors.red.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isClosed
                      ? 'Cerrado'
                      : (openTime != null && closeTime != null)
                      ? '$openTime - $closeTime'
                      : 'No disponible',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isClosed
                        ? Colors.red.shade300
                        : Colors.green.shade300,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
