import 'dart:io';

class ApiConfig {
  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    }

    return "http://localhost:3000";
  }

  static final String baseUrl = _getBaseUrl();
}