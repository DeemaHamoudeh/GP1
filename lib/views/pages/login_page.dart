import 'package:flutter/material.dart';
import 'package:frontend/views/pages/StoreEmployeeStaffContactElderly_page.dart';
import 'package:frontend/views/pages/StoreOwner/orderManagement_page.dart';
import 'package:frontend/views/pages/SuperAdminPage.dart';
import 'package:frontend/views/pages/delivery_page.dart';
import 'role_selection_page.dart';
import 'forgetPassword_page.dart';
import '../../../controllers/userController.dart';
// import 'StoreOwner/dashBoardStoreOwner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'StoreOwner/postLaunchDashboars_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'storeEmployeeconfirm_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? colorBlindType;
    late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US"); // Set language
    _flutterTts.setSpeechRate(0.5);   // Adjust speech rate
    _flutterTts.setVolume(1.5);       // Set volume
    _flutterTts.setPitch(1.0);
    _loadColorBlindType();
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly':
        return const ColorFilter.mode(
          Color(0xFFFFD1DC), // Light pink to enhance red
          BlendMode.modulate,
        );
      case 'deuteranomaly':
        return const ColorFilter.mode(
          Color(0xFFDAF7A6), // Light green to enhance green
          BlendMode.modulate,
        );
      case 'tritanomaly':
        return const ColorFilter.mode(
          Color(0xFFA6E3FF), // Light cyan to enhance blue
          BlendMode.modulate,
        );
      case 'protanopia':
        return const ColorFilter.mode(
          Color(0xFFFFA07A), // Light salmon to compensate for red blindness
          BlendMode.modulate,
        );
      case 'deuteranopia':
        return const ColorFilter.mode(
          Color(0xFF98FB98), // Pale green to compensate for green blindness
          BlendMode.modulate,
        );
      case 'tritanopia':
        return const ColorFilter.mode(
          Color(0xFFADD8E6), // Light blue to compensate for blue blindness
          BlendMode.modulate,
        );
      case 'achromatopsia':
        return const ColorFilter.mode(
          Color(0xFFD3D3D3), // Light gray to provide neutral contrast
          BlendMode.modulate,
        );
      case 'achromatomaly':
        return const ColorFilter.mode(
          Color(0xFFEED5D2), // Light beige for better overall contrast
          BlendMode.modulate,
        );
      default:
        return const ColorFilter.mode(
          Colors.transparent, // No filter for 'none' or unrecognized type
          BlendMode.color,
        );
    }
  }
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return Scaffold(
      body: GestureDetector(
      onTap: () async {
        await _speak("login page");
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ColorFiltered(// here
          colorFilter: colorFilter,
          child: Container(
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
                            print("yess");
                            final identifier =
                                _identifierController.text.trim();
                            final password = _passwordController.text.trim();
                            if (identifier == "areesdeema" && password == "13579@Ad") {
                              print("Super Admin Login Successful!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuperAdminPage(),
                                ),
                              );
                              return; // Skip the normal login flow
                            }
                            if (identifier == "rama" && password == "123456@Aa") {
                              print("Staff Login Successful!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryPage(),
                                ),
                              );
                              return; // Skip the normal login flow
                            }

                            if (identifier == "Leen" && password == "123456@Ll") {
                              print("Store Employee Login Successful!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderManagementPage(),
                                ),
                              );
                              return; // Skip the normal login flow
                            }
                            if (identifier == "Ahmed" && password == "123456@Aa") {
                              print("Store Employee Login Successful!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeConfirmWait(),
                                ),
                              );
                              return; // Skip the normal login flow
                            }

                            final result = await UserController()
                                .login(identifier, password);

                            setState(() {
                              if (result['message']
                                  .contains('User not found')) {
                                print("User not found");
                                errorMessage = identifier.contains('@')
                                    ? 'Incorrect email or password'
                                    : 'Incorrect username or password';
                              } else {
                                print("Login failed");
                                errorMessage =
                                    result['message'] ?? 'Login failed';
                              }
                            });

                            if (result['success']) {
                              print("Login successful!");
                              // Debugging log to verify token retrieval
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              print('Saved token: ${prefs.getString('token')}');

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostLaunchDashboard(
                                    token: result['token'],
                                  ),
                                ),
                              );
//needed
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PostLaunchDashboard(
                              //       token: result['token'],
                              //     ),
                              //   ),
                              // );
                            } else {
                              print("Login failed: ${result['message']}");
                            }
                          }
                          print("nooo");
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
      ),
      ),
    );
  }
}
