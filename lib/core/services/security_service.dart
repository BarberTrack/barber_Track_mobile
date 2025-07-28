import 'package:secure_application/secure_application.dart';

class SecurityService {
  static SecurityService? _instance;
  static SecurityService get instance => _instance ??= SecurityService._();
  SecurityService._();

  SecureApplicationController? _controller;

  void initialize(SecureApplicationController? controller) {
    _controller = controller;
  }

  void enableScreenSecurity() {
    try {
      if (_controller == null) {
        return;
      }

      _controller?.secure();
    } catch (e) {
      throw Exception('Error al activar la protección de pantalla: $e');
    }
  }

  void disableScreenSecurity() {
    try {
      if (_controller == null) {
        return;
      }

      _controller?.open();
    } catch (e) {
      throw Exception('Error al desactivar la protección de pantalla: $e');
    }
  }

  bool get isSecure => _controller?.secured ?? false;
}
