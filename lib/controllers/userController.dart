import '../helpers/user_helper.dart';
import '../models/userModel.dart';
import 'dart:convert'; // Add this to use json.decode

class UserController {
  // Login Function
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await userApiHelper.post('users/login', {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Login successful!',
        };
      } else {
        return {
          'success': false,
          'message': 'User not found or incorrect password',
        };
      }
    } catch (error) {
      print("Error during login: $error");
      return {
        'success': false,
        'message': 'An error occurred during login',
      };
    }
  }

  // Signup Function
  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? role,
    String? plan,
    String? condition,
  }) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return {'success': false, 'message': "All fields are required."};
    }

    if (password != confirmPassword) {
      return {'success': false, 'message': "Passwords do not match."};
    }

    UserModel user = UserModel(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      role: role,
      plan: plan,
      condition: condition,
    );

    try {
      final response = await userApiHelper.post(
        'users/signup',
        user.toJson(forSignup: true),
      );

      if (response.statusCode == 201) {
        // Assuming 201 means success
        return {'success': true, 'message': "Signup successful!"};
      } else {
        // Handle error responses
        final responseBody = json.decode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? "Signup failed."
        };
      }
    } catch (error) {
      // Handle unexpected errors
      return {'success': false, 'message': "An error occurred: $error"};
    }
  }
}
