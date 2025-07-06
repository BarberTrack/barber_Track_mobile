import 'package:flutter/material.dart';
import '../../domain/entities/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900.withOpacity(0.8),
            Colors.grey.shade800.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: service.isActive
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (service.isActive ? Colors.green : Colors.red).withOpacity(
              0.1,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y estado
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: service.isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: service.isActive
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    service.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: service.isActive
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Descripción
            Text(
              service.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade300,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Información del servicio
            Row(
              children: [
                // Precio
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.attach_money_rounded,
                    label: 'Precio',
                    value: '\$${service.price}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                // Duración
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.access_time_rounded,
                    label: 'Duración',
                    value: '${service.durationMinutes} min',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            // Barberos asignados
            if (service.barberAssignments.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Barberos disponibles:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...service.barberAssignments
                  .map((assignment) => _buildBarberAssignment(assignment))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarberAssignment(BarberAssignment assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.person_rounded, color: Colors.purple.shade300, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${assignment.firstName} ${assignment.lastName}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (assignment.isPreferred)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Preferido',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.amber.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            '\$${assignment.specialPrice.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
