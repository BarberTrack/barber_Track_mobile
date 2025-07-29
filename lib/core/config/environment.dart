import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ??
        'https://barbertrack-gateway.up.railway.app/api/v1';
  }

  static int get connectTimeout {
    return int.tryParse(dotenv.env['API_CONNECT_TIMEOUT'] ?? '30') ?? 30;
  }

  static int get receiveTimeout {
    return int.tryParse(dotenv.env['API_RECEIVE_TIMEOUT'] ?? '30') ?? 30;
  }

  static int get sendTimeout {
    return int.tryParse(dotenv.env['API_SEND_TIMEOUT'] ?? '30') ?? 30;
  }
}
