import 'package:flutter/material.dart';

class BusinessHoursWidget extends StatelessWidget {
  final Map<String, dynamic> businessHours;

  const BusinessHoursWidget({super.key, required this.businessHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 12,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade900, Colors.grey.shade800],
            ),
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.access_time_filled,
                        color: Colors.orange.shade300,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Horario de Atención',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildHoursList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoursList() {
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
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isClosed
                  ? [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.2)]
                  : [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.2),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isClosed
                          ? Colors.red.shade400
                          : Colors.green.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    day['name']!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isClosed
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isClosed
                        ? Colors.red.withOpacity(0.3)
                        : Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  isClosed
                      ? 'Cerrado'
                      : (openTime != null && closeTime != null)
                      ? '$openTime - $closeTime'
                      : 'No disponible',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isClosed
                        ? Colors.red.shade300
                        : Colors.green.shade300,
                    letterSpacing: 0.3,
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
