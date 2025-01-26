import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/user_helper.dart';

class ProductController {
  static Future<Map<String, dynamic>> addProduct({
    required String token,
    required Map<String, dynamic> productData,
  }) async {
    print("🛠️ Sending Token in Headers:");
    print(token);

    try {
      final response = await userApiHelper.post(
        "product/addProduct",
        productData,
        headers: {
          "Authorization": "Bearer $token", // ✅ Ensure token is included
        },
      );

      print("📩 Response Status Code: ${response.statusCode}");
      print("📩 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {"success": true, "message": responseData["message"]};
      } else {
        return {"success": false, "message": "Server Error: ${response.body}"};
      }
    } catch (error) {
      print("❌ Error: $error");
      return {"success": false, "message": "Something went wrong: $error"};
    }
  }
}
