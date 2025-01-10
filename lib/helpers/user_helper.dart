import 'dart:convert';
import 'package:http/http.dart' as http;

class userApiHelper {
  static const String baseUrl = 'http://10.0.2.2:3000/storeMaster';

  // Static method for POST requests
  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
  }

  // Static method for GET requests
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
  }
}
