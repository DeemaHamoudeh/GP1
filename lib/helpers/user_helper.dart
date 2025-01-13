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

  // Static method for GET requests with optional headers
  static Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        ...?headers, // Add custom headers if provided
      },
    );
  }

  // Static method for PUT requests with optional headers
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        ...?headers, // Add custom headers if provided
      },
      body: json.encode(body), // Encode the body as JSON
    );
  }
}
