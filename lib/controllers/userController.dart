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

  // Send Email Function for Password Reset
  Future<Map<String, dynamic>> sendEmail(String email) async {
    try {
      final response =
          await userApiHelper.post('users/reset-password/request-Email', {
        'email': email,
      });

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email sent successfully.'};
      } else {
        final responseBody = json.decode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Failed to send email.'
        };
      }
    } catch (error) {
      print("Error during sendEmail: $error");
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  // Verify PIN function
  Future<Map<String, dynamic>> verifyPin(String email, String pinCode) async {
    try {
      final response =
          await userApiHelper.post('users/reset-password/verify-pin', {
        'email': email,
        'temporalPin': {
          'code': pinCode,
        },
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return {
          'success': true,
          'message': responseBody['message'] ?? 'PIN verification successful.'
        };
      } else {
        final responseBody = json.decode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Failed to verify PIN.'
        };
      }
    } catch (error) {
      print("Error during PIN verification: $error");
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  // Create New Password Function
  Future<Map<String, dynamic>> createNewPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      return {'success': false, 'message': "Passwords do not match."};
    }

    try {
      print(email);
      print(newPassword);
      print(confirmPassword);

      final response = await userApiHelper.post(
        'users/reset-password/create-password',
        CreatePasswordRequest(
          email: email,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Password reset successful.'
        };
      } else {
        final responseBody = json.decode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Failed to create new password.'
        };
      }
    } catch (error) {
      print("Error during createNewPassword: $error");
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }
}
