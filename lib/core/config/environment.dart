import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_BASE_URL environment variable is required but not found',
      );
    }
    return url;
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
