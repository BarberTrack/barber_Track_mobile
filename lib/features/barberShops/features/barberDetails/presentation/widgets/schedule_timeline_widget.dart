import 'package:flutter/material.dart';

class ScheduleTimelineWidget extends StatelessWidget {
  final Map<String, dynamic> businessHours;

  const ScheduleTimelineWidget({super.key, required this.businessHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Horarios de Atención',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Esta semana',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade900, Colors.grey.shade800],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(children: _buildTimelineItems()),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimelineItems() {
    final days = [
      {'key': 'monday', 'name': 'Lun', 'fullName': 'Lunes'},
      {'key': 'tuesday', 'name': 'Mar', 'fullName': 'Martes'},
      {'key': 'wednesday', 'name': 'Mié', 'fullName': 'Miércoles'},
      {'key': 'thursday', 'name': 'Jue', 'fullName': 'Jueves'},
      {'key': 'friday', 'name': 'Vie', 'fullName': 'Viernes'},
      {'key': 'saturday', 'name': 'Sáb', 'fullName': 'Sábado'},
      {'key': 'sunday', 'name': 'Dom', 'fullName': 'Domingo'},
    ];

    return days.asMap().entries.map((entry) {
      final index = entry.key;
      final day = entry.value;
      final isLast = index == days.length - 1;

      return _buildTimelineItem(
        day: day,
        isLast: isLast,
        isToday: _isToday(day['key']!),
      );
    }).toList();
  }

  Widget _buildTimelineItem({
    required Map<String, String> day,
    required bool isLast,
    required bool isToday,
  }) {
    final dayData = businessHours[day['key']] as Map<String, dynamic>?;
    final isClosed = dayData?['closed'] == true;
    final openTime = dayData?['open'] as String?;
    final closeTime = dayData?['close'] as String?;

    return Column(
      children: [
        Row(
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isToday
                        ? Colors.blueAccent
                        : isClosed
                        ? Colors.red.shade400
                        : Colors.green.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isToday
                                    ? Colors.blueAccent
                                    : isClosed
                                    ? Colors.red.shade400
                                    : Colors.green.shade400)
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey.shade600, Colors.grey.shade700],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Day content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isToday
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isToday
                        ? Colors.blueAccent.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day['fullName']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isToday ? Colors.blueAccent : Colors.white,
                          ),
                        ),
                        if (isToday)
                          Text(
                            'Hoy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent.withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),

                    // Time display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isClosed
                            ? Colors.red.withOpacity(0.15)
                            : Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
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
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isClosed
                              ? Colors.red.shade300
                              : Colors.green.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!isLast) const SizedBox(height: 8),
      ],
    );
  }

  bool _isToday(String dayKey) {
    final today = DateTime.now().weekday;
    final dayMap = {
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
      'sunday': 7,
    };
    return dayMap[dayKey] == today;
  }
}
