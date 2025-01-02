import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/userController.dart';
import 'correctlyRestPassword.dart';

class CreatePasswordPage extends StatefulWidget {
  final String email;
  final String pin;
  CreatePasswordPage({required this.email, required this.pin});

  @override
  _CreatePasswordPageState createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UserController _userController = UserController();
  bool isPasswordValid = false;
  bool hasPasswordBeenInteracted = false;
  bool hasConfirmPasswordBeenInteracted = false;
  String? colorBlindType; //111

  @override
  void initState() {
    super.initState();
    _loadColorBlindType(); //111
  }

  Future<void> _loadColorBlindType() async { //111
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  ColorFilter _getColorFilter(String? type) { //111
    switch (type) {
      case 'protanomaly':
        return const ColorFilter.mode(Color(0xFFFFD1DC), BlendMode.modulate);
      case 'deuteranomaly':
        return const ColorFilter.mode(Color(0xFFDAF7A6), BlendMode.modulate);
      case 'tritanomaly':
        return const ColorFilter.mode(Color(0xFFA6E3FF), BlendMode.modulate);
      case 'protanopia':
        return const ColorFilter.mode(Color(0xFFFFA07A), BlendMode.modulate);
      case 'deuteranopia':
        return const ColorFilter.mode(Color(0xFF98FB98), BlendMode.modulate);
      case 'tritanopia':
        return const ColorFilter.mode(Color(0xFFADD8E6), BlendMode.modulate);
      case 'achromatopsia':
        return const ColorFilter.mode(Color(0xFFD3D3D3), BlendMode.modulate);
      case 'achromatomaly':
        return const ColorFilter.mode(Color(0xFFEED5D2), BlendMode.modulate);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.color);
    }
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

  void _checkPasswordStrength(String value) {
    setState(() {
      isPasswordValid = _validatePassword(value) == null;
      hasPasswordBeenInteracted = true;
    });
  }

  // Function to handle password change
  void _handlePasswordChange(
      BuildContext context, String newPassword, String confirmPassword) async {
    // Call the createNewPassword function on the instance
    Map<String, dynamic> result = await _userController.createNewPassword(
      email: widget.email,
      newPassword: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (result['success']) {
      // Password created successfully
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(result['message'])),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordResetSuccessPage()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType); //111

    return Scaffold(
      appBar: AppBar(title: Text('Create New Password')),
      body: ColorFiltered( //111
        colorFilter: colorFilter, //111
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset(
                        'assets/images/logPages/correctPassword.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your new password must be different from previously used passwords.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: isPasswordValid
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          )
                        : null,
                    errorText: hasPasswordBeenInteracted
                        ? _validatePassword(_passwordController.text)
                        : null,
                  ),
                  onChanged: (value) {
                    _checkPasswordStrength(value);
                  },
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.0,
                      ),
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
                        : null,
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
                  obscureText: true,
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    _handlePasswordChange(
                      context,
                      _passwordController.text.trim(),
                      _confirmPasswordController.text.trim(),
                    );
                  },
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
