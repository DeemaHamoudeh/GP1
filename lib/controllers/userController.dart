import '../helpers/user_helper.dart';
import '../models/userModel.dart';
import 'dart:convert'; // Add this to use json.decode
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class UserController {
  // Login Function
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await userApiHelper.post('users/login', {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseBody =
            json.decode(response.body); // Parse the response body
        return {
          'success': true,
          'message': 'Login successful!',
          'token': responseBody['token'], // Include the token in the response
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

  String? extractToken(String responseBody) {
    try {
      final decodedBody = json.decode(responseBody);
      return decodedBody['token'];
    } catch (e) {
      print("Error extracting token: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? role,
    required String plan,
    String? condition,
    String? paymentMethod,
    Map<String, dynamic>? paymentDetails,
    String? paypalEmail,
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

    try {
      if (plan.toLowerCase() == "basic") {
        print("Handling free plan signup");
        final response = await userApiHelper.post(
          'users/signup',
          {
            'username': username,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword,
            'role': role,
            'plan': plan,
            'condition': condition,
          },
        );

        if (response.statusCode == 201) {
          final responseBody = json.decode(response.body);
          return {
            'success': true,
            'message': responseBody['message'] ?? "Signup successful!",
            'token': responseBody['token'],
          };
        } else {
          final responseBody = json.decode(response.body);
          return {
            'success': false,
            'message': responseBody['message'] ?? "Signup failed."
          };
        }
      }

      if (plan.toLowerCase() == "premium" && paymentMethod == "PayPal") {
        print("Handling premium plan with PayPal payment");
        final response = await userApiHelper.post(
          'users/signup',
          {
            'username': username,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword,
            'role': role,
            'plan': plan,
            'condition': condition,
            'paymentMethod': paymentMethod,
            'paypalEmail': paypalEmail,
          },
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final approvalUrl = responseBody['approvalUrl'];

          if (approvalUrl != null && approvalUrl.isNotEmpty) {
            print("Launching PayPal URL: $approvalUrl");
            final redirectedUrl =
                await monitorPayPalRedirect(Uri.parse(approvalUrl));

            if (redirectedUrl == null || redirectedUrl.isEmpty) {
              return {'success': false, 'message': "Payment not completed."};
            }

            // No need to call the capture endpoint here, as it's handled in `main.dart`.
            return {'success': true, 'message': "Payment redirection handled."};
          } else {
            return {'success': false, 'message': "Approval URL is missing."};
          }
        } else {
          final responseBody = json.decode(response.body);
          return {
            'success': false,
            'message': responseBody['message'] ?? "Signup failed."
          };
        }
      }

      return {'success': false, 'message': "Invalid plan or payment method."};
    } catch (error) {
      print("Error during signup: $error");
      return {'success': false, 'message': "An error occurred: $error"};
    }
  }

  Future<String?> monitorPayPalRedirect(Uri approvalUrl) async {
    try {
      if (await canLaunchUrl(approvalUrl)) {
        await launchUrl(approvalUrl, mode: LaunchMode.externalApplication);
        print("PayPal approval URL launched: $approvalUrl");

        // Capture deep link directly
        final String? initialLink = await getInitialLink();
        print("Initial link captured: $initialLink");

        if (initialLink != null) {
          final Uri redirectedUri = Uri.parse(initialLink);

          // Return the URI as a string
          return redirectedUri.toString();
        }

        // If initial link is null, fall back to listening on uriLinkStream
        final Uri? result = await uriLinkStream
            .firstWhere((link) => link != null, orElse: () => null);
        print("Stream captured redirected URL: $result");

        if (result != null) {
          return result.toString();
        }
      } else {
        print("Unable to launch PayPal approval URL.");
      }
    } catch (e) {
      print("Error in monitorPayPalRedirect: $e");
    }

    return null; // Default case for failure
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
