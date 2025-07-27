import 'package:flutter/material.dart';

class HeroSectionWidget extends StatelessWidget {
  final dynamic business;

  const HeroSectionWidget({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Calcular altura dinámica basada en la descripción
    final hasDescription =
        business.description != null && business.description.isNotEmpty;
    final estimatedHeight = _calculateContainerHeight(
      isSmallScreen,
      hasDescription,
      business.description,
    );

    // Determinar si está abierto o cerrado
    final businessStatus = _getBusinessStatus();

    return Container(
      height: estimatedHeight,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent, Colors.blueAccent.shade700],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón decorativo de fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),

          // Círculos decorativos
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con icono y badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.content_cut_rounded,
                        color: Colors.white,
                        size: isSmallScreen ? 28 : 32,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: businessStatus['isOpen']
                            ? Colors.green.withOpacity(0.9)
                            : Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            businessStatus['text'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Nombre del negocio - Compacto
                Text(
                  business.name ?? 'Barbería',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Descripción - Expandida para mostrar más texto
                if (hasDescription)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        business.description,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 15,
                          color: Colors.white.withOpacity(0.95),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: isSmallScreen ? 4 : 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Rating section - Ahora muestra el rating real
                Row(
                  children: [
                    _buildRatingStat(
                      rating: business.ratingAverage?.toDouble() ?? 0.0,
                      totalReviews: business.totalReviews ?? 0,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Determina el estado actual del negocio (abierto/cerrado)
  Map<String, dynamic> _getBusinessStatus() {
    // Verificar si el negocio está activo
    if (business.isActive != true) {
      print('DEBUG: Negocio inactivo');
      return {'isOpen': false, 'text': 'Cerrado'};
    }

    // Verificar si tenemos horarios
    if (business.businessHours == null) {
      print('DEBUG: Sin horarios definidos');
      return {'isOpen': false, 'text': 'Cerrado'};
    }

    // Obtener el día actual
    final now = DateTime.now();
    final currentDay = _getCurrentDayKey(now.weekday);
    print(
      'DEBUG: Día actual: $currentDay, Hora actual: ${now.hour}:${now.minute}',
    );

    // Obtener datos del día actual
    final dayData = business.businessHours[currentDay] as Map<String, dynamic>?;
    print('DEBUG: Datos del día: $dayData');

    // Si no hay datos para el día o está marcado como cerrado
    if (dayData == null || dayData['closed'] == true) {
      print('DEBUG: Día marcado como cerrado');
      return {'isOpen': false, 'text': 'Cerrado'};
    }

    // Obtener horarios de apertura y cierre
    final openTime = dayData['open'] as String?;
    final closeTime = dayData['close'] as String?;
    print('DEBUG: Horario - Abre: $openTime, Cierra: $closeTime');

    // Si no hay horarios definidos
    if (openTime == null || closeTime == null) {
      print('DEBUG: Horarios no definidos');
      return {'isOpen': false, 'text': 'Cerrado'};
    }

    // Verificar si está dentro del horario
    final isWithinHours = _isWithinBusinessHours(now, openTime, closeTime);
    print('DEBUG: ¿Está dentro del horario? $isWithinHours');

    return {
      'isOpen': isWithinHours,
      'text': isWithinHours ? 'Abierto' : 'Cerrado',
    };
  }

  /// Obtiene la clave del día actual para los horarios
  String _getCurrentDayKey(int weekday) {
    final dayMap = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    return dayMap[weekday] ?? 'monday';
  }

  /// Verifica si la hora actual está dentro del horario de negocio
  bool _isWithinBusinessHours(DateTime now, String openTime, String closeTime) {
    try {
      // Parsear horarios (formato esperado: "HH:mm")
      final openParts = openTime.split(':');
      final closeParts = closeTime.split(':');

      if (openParts.length != 2 || closeParts.length != 2) {
        return false;
      }

      final openHour = int.parse(openParts[0]);
      final openMinute = int.parse(openParts[1]);
      final closeHour = int.parse(closeParts[0]);
      final closeMinute = int.parse(closeParts[1]);

      // Crear DateTime para horarios de hoy
      final today = DateTime(now.year, now.month, now.day);
      final openDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        openHour,
        openMinute,
      );
      var closeDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        closeHour,
        closeMinute,
      );

      // Si el horario de cierre es antes que el de apertura,
      // significa que cierra al día siguiente (ej: 22:00 - 02:00)
      if (closeDateTime.isBefore(openDateTime) ||
          (closeHour < openHour) ||
          (closeHour == openHour && closeMinute <= openMinute)) {
        closeDateTime = closeDateTime.add(const Duration(days: 1));
      }

      // Verificar si la hora actual está dentro del rango (inclusivo)
      return (now.isAtSameMomentAs(openDateTime) ||
              now.isAfter(openDateTime)) &&
          (now.isAtSameMomentAs(closeDateTime) || now.isBefore(closeDateTime));
    } catch (e) {
      // En caso de error, asumir que está cerrado
      return false;
    }
  }

  double _calculateContainerHeight(
    bool isSmallScreen,
    bool hasDescription,
    String? description,
  ) {
    double baseHeight = isSmallScreen ? 280 : 260;

    if (hasDescription && description != null) {
      // Estimar líneas basado en la longitud del texto
      int estimatedLines = (description.length / (isSmallScreen ? 35 : 45))
          .ceil();
      estimatedLines = estimatedLines.clamp(1, isSmallScreen ? 4 : 5);

      // Agregar altura extra por línea de descripción
      double extraHeight = estimatedLines * (isSmallScreen ? 18 : 20);
      return baseHeight + extraHeight;
    }

    return baseHeight;
  }

  Widget _buildRatingStat({
    required double rating,
    required int totalReviews,
    required bool isSmallScreen,
  }) {
    // Formatear el rating para mostrar máximo 1 decimal
    String formattedRating = rating.toStringAsFixed(1);

    // Si termina en .0, mostrar sin decimales
    if (formattedRating.endsWith('.0')) {
      formattedRating = rating.toStringAsFixed(0);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Estrella con fondo
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: isSmallScreen ? 14 : 16,
            ),
          ),
          const SizedBox(width: 8),

          // Rating y reviews
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedRating,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 16 : 18,
                ),
              ),
              if (totalReviews > 0)
                Text(
                  '$totalReviews reseña${totalReviews != 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
