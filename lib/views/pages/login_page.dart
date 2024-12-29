import 'package:flutter/material.dart';
import 'role_selection_page.dart';
import 'forgetPassword_page.dart';
import '../../../controllers/userController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Add the wallpaper here
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logPages/login-wallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 180),
                      const Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 39,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Username Row with Icon and TextField
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              child: TextField(
                                controller: _identifierController,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Username or Email",
                                  labelStyle:
                                      const TextStyle(color: Colors.black54),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.teal, width: 2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Password Row with Icon and TextField
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 350),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: const TextStyle(
                                          color: Colors.black54),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.teal, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                                print("Navigate to Reset Password screen");
                              },
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      if (errorMessage.isNotEmpty)
                        Text(errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 16)),

                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Collect form data
                            final identifier =
                                _identifierController.text.trim();
                            final password = _passwordController.text.trim();
                            print("Lo");
                            // Call the login function in UserController
                            final result = await UserController()
                                .login(identifier, password);

                            setState(() {
                              // Check if it's an incorrect username or email
                              if (result['message']
                                  .contains('User not found')) {
                                // If the message indicates the user wasn't found
                                errorMessage = identifier.contains('@')
                                    ? 'Incorrect email or password'
                                    : 'Incorrect username or password';
                              } else {
                                errorMessage =
                                    result['message'] ?? 'Login failed';
                              }
                            });
                            print("Login");

                            // Optionally, navigate or do something based on the result
                            if (result['success']) {
                              print("Login successful!");
                              // Navigate to another screen or show a success dialog/snackbar
                            } else {
                              print("Login failed: ${result['message']}");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Text
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RoleSelectionPage()),
                          );
                          print("Navigate to Sign Up screen");
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
