import '../helpers/user_helper.dart';
import '../models/userModel.dart';
import 'dart:convert'; // Add this to use json.decode
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreController {
  Future<Map<String, dynamic>> updateStoreDetails(
      String token, String storeId, Map<String, dynamic> storeData) async {
    try {
      final response = await userApiHelper.put(
        'store/updateStoreDetails/$storeId', // ✅ Now includes store ID
        storeData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("🛠️ Server Response: ${response.body}"); // ✅ Debugging Print

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return {'success': true, 'data': responseBody['store']};
      } else {
        final responseBody = json.decode(response.body);
        print("❌ Failed response status: ${response.statusCode}");
        print("❌ Response body: ${response.body}");

        return {
          'success': false,
          'message': responseBody['message'] ?? "Failed to update store."
        };
      }
    } catch (error) {
      print("❌ Error updating store details: $error");
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  Future<Map<String, dynamic>> getStoreDetails(
      String token, String storeId) async {
    try {
      print("enter getStoreDetails ");

      final response = await userApiHelper.get(
        'store/getStoreDetails/$storeId',
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      print("called api ");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Store details fetched successfully: $data");
        return {"success": true, "data": data['data']};
      } else {
        final errorData = json.decode(response.body);
        print("❌ Failed to fetch store details: ${errorData['message']}");
        return {"success": false, "message": errorData['message']};
      }
    } catch (error) {
      print("❌ Error fetching store details: $error");
      return {"success": false, "message": "Server error"};
    }
  }
}
