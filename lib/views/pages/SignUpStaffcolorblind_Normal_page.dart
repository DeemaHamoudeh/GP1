import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:frontend/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
// import 'jobPosts_page.dart';
import 'delivery_page.dart';
import 'arrange_page.dart';
import 'prepareOrders_page.dart';

class SignUpStaffColorBlindNormalPage extends StatefulWidget {
  const SignUpStaffColorBlindNormalPage({
    super.key,
  });

  @override
  State<SignUpStaffColorBlindNormalPage> createState() =>
      _SignUpStoreStoreEmployeePageState();
}

class _SignUpStoreStoreEmployeePageState
    extends State<SignUpStaffColorBlindNormalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // final FocusNode _usernameFocusNode = FocusNode(); // Add FocusNode
  bool isUsernameValid = false; // New variable to track username validity
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool hasUsernameBeenInteracted = false;
  bool hasEmailBeenInteracted = false;
  bool hasPasswordBeenInteracted = false;
  bool hasConfirmPasswordBeenInteracted = false;

  final List<String> _reservedWords = ['null', 'admin', 'support'];

  String? colorBlindType;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadColorBlindNormalType();
  }

  // Load the saved color-blind type from SharedPreferences
  Future<void> _loadColorBlindNormalType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  // Save username to SharedPreferences
  Future<void> _saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username.";
    }
    if (value.length < 3 || value.length > 15) {
      return "Username must be between 3 to 15 characters.";
    }
    if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value)) {
      return "Username can only contain letters, numbers, '_' and '.'.";
    }
    if (value.replaceAll(RegExp(r'[^a-zA-Z]'), '').length < 3) {
      return "Username must contain at least 3 letters.";
    }
    if (_reservedWords.contains(value.toLowerCase())) {
      return "This username is reserved. Please choose another.";
    }
    return null; // Valid username
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email.";
    }
    // Simple regex for email validation
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null; // Valid email
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password.";
    }

    // Check if the password is at least 9 characters long
    if (value.length < 9) {
      return "Password must be at least 9 characters.";
    }

    // Check for at least one letter
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return "Password must contain at least one letter.";
    }

    // Check for at least one number
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Password must contain at least one number.";
    }

    // Check for at least one special character
    if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
      return "Password must contain at least one special character.";
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  // Map the colorBlindType string to a ColorFilter
  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly': // Reduced sensitivity to red
        return const ColorFilter.mode(
          Color(0xFFFFD1DC), // Light pink to enhance red
          BlendMode.modulate,
        );
      case 'deuteranomaly': // Reduced sensitivity to green
        return const ColorFilter.mode(
          Color(0xFFDAF7A6), // Light green to enhance green
          BlendMode.modulate,
        );
      case 'tritanomaly': // Reduced sensitivity to blue
        return const ColorFilter.mode(
          Color(0xFFA6E3FF), // Light cyan to enhance blue
          BlendMode.modulate,
        );
      case 'protanopia': // Red-blind
        return const ColorFilter.mode(
          Color(0xFFFFA07A), // Light salmon to compensate for red blindness
          BlendMode.modulate,
        );
      case 'deuteranopia': // Green-blind
        return const ColorFilter.mode(
          Color(0xFF98FB98), // Pale green to compensate for green blindness
          BlendMode.modulate,
        );
      case 'tritanopia': // Blue-blind
        return const ColorFilter.mode(
          Color(0xFFADD8E6), // Light blue to compensate for blue blindness
          BlendMode.modulate,
        );
      case 'achromatopsia': // Total color blindness
        return const ColorFilter.mode(
          Color(0xFFD3D3D3), // Light gray to provide neutral contrast
          BlendMode.modulate,
        );
      case 'achromatomaly': // Reduced total color sensitivity
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

  void _showConfirmationMessage(String employeeID) async {
    if (_formKey.currentState!.validate()) {
      // Save username to SharedPreferences
      if (username != null) await _saveUsername(username!);

      // Navigate based on employee ID
      if (employeeID == "98006") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  DeliveryPage()),
        );
      } else if (employeeID == "65223") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ArrangePage()),
        );
      } else if (employeeID == "38765") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PrepareOrdersPage()),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: const Text(
              "Invalid Employee ID",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return MaterialApp(
      home: Scaffold(
        body: ColorFiltered(
          colorFilter: colorFilter,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logPages/wall3.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create new account",
                          style: const TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign up as Staff (${colorBlindType ?? 'Normal Vision'})",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.basicBackgroundColor,
                              size: 24,
                            ),
                            suffixIcon: isUsernameValid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                : null, // Show check icon if valid

                            errorText: hasUsernameBeenInteracted
                                ? _validateUsername(_usernameController.text)
                                : null, // Only show error after user interaction
                            // Only show error if field is focused
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_.]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              // Trigger real-time validation
                              isUsernameValid = _validateUsername(value) == null;
                              hasUsernameBeenInteracted = true;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.basicBackgroundColor,
                              size: 24,
                            ),
                            suffixIcon: isEmailValid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                : null, // Show check icon if valid
                            errorText: hasEmailBeenInteracted
                                ? _validateEmail(_emailController.text)
                                : null, // Show error after interaction
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              isEmailValid = _validateEmail(value) == null;
                              hasEmailBeenInteracted = true;
                            });
                          },
                          validator: _validateEmail, // Apply validation here
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.basicBackgroundColor,
                              size: 24,
                            ),
                            suffixIcon: isPasswordValid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                : null, // Show check icon if valid
                            errorText: hasPasswordBeenInteracted
                                ? _validatePassword(_passwordController.text)
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              isPasswordValid = _validatePassword(value) == null;
                              hasPasswordBeenInteracted = true;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.basicBackgroundColor,
                              size: 24,
                            ),
                            suffixIcon: _passwordController.text.isNotEmpty &&
                                    _confirmPasswordController.text.isNotEmpty &&
                                    _confirmPasswordController.text ==
                                        _passwordController.text
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                : null, // Show check icon if passwords match
                            errorText: hasConfirmPasswordBeenInteracted
                                ? _validateConfirmPassword(
                                    _confirmPasswordController.text)
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              hasConfirmPasswordBeenInteracted = true;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Phone Number",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) => value!.isEmpty
                              ? "Please enter your phone number"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Employee ID",
                          icon: Icons.lock,
                          controller: _employeeIdController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your ID";
                            } else if (value.length != 5) {
                              return "Please enter exactly 5 digits";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                    final employeeID = _employeeIdController.text;
                                _showConfirmationMessage(employeeID);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent,
                            ).copyWith(
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    AppColors.basicBackgroundColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                        100, 60, 172, 161),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88, minHeight: 44),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.check_circle,
                                        color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text("Submit"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: Icon(icon, size: 24),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
