import 'package:flutter/material.dart';

class ServicesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ServicesErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade900.withOpacity(0.3),
            Colors.red.shade800.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de error
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red.shade300,
            ),
          ),

          const SizedBox(height: 20),

          // Título
          Text(
            'Error al cargar servicios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Mensaje de error
          Text(
            _getErrorMessage(message),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade300,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Botón de reintentar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.refresh_rounded, size: 20),
              ),
              label: Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String originalMessage) {
    if (originalMessage.toLowerCase().contains('conexión') ||
        originalMessage.toLowerCase().contains('connection') ||
        originalMessage.toLowerCase().contains('network')) {
      return 'Revisa tu conexión a internet e inténtalo nuevamente.';
    } else if (originalMessage.toLowerCase().contains('timeout') ||
        originalMessage.toLowerCase().contains('tiempo')) {
      return 'La solicitud tardó demasiado. Verifica tu conexión.';
    } else if (originalMessage.toLowerCase().contains('server') ||
        originalMessage.toLowerCase().contains('servidor')) {
      return 'Hay un problema temporal con el servidor. Inténtalo más tarde.';
    } else {
      return 'Ocurrió un error inesperado. Por favor, inténtalo nuevamente.';
    }
  }
}
