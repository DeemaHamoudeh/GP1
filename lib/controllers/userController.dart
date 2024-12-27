import '../helpers/user_helper.dart';
import '../models/userModel.dart';

class UserController {
  void login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      print("Username and Password cannot be empty.");
      return;
    }

    UserModel user = UserModel(identifier: username, password: password);

    try {
      // Correctly calling the static method
      final response = await userApiHelper.post('users/login', user.toJson());

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Handle success
        print("Login successful!");
      } else {
        // Handle failure
        print("Login failed: ${response.body}");
      }
    } catch (error) {
      print("Error occurred during login: $error");
    }
  }
}
