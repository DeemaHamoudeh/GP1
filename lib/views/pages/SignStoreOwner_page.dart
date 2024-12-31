import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:frontend/constants/colors.dart';
<<<<<<< HEAD
=======
import 'choosePlan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/userController.dart';
>>>>>>> 9b4561b5e169e7bf87c457bcda79ed570ea1d7a4

class SignUpStoreOwnerPage extends StatefulWidget {
  final String role;
  final String plan;

  const SignUpStoreOwnerPage({
    Key? key,
    required this.role,
    required this.plan, 
  }) : super(key: key);

  @override
  State<SignUpStoreOwnerPage> createState() => _SignUpStoreOwnerPageState();
}

class _SignUpStoreOwnerPageState extends State<SignUpStoreOwnerPage> {
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode(); // Add FocusNode
  bool isPaidAccount = false;
  bool isUsernameValid = false; // New variable to track username validity
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool hasUsernameBeenInteracted = false;
  bool hasEmailBeenInteracted = false;
  bool hasPasswordBeenInteracted = false;
  bool hasConfirmPasswordBeenInteracted = false;

  String? selectedAccessibility; // Variable to store selected accessibility
  final List<String> _reservedWords = ['null', 'admin', 'support'];

  @override
  void initState() {
    super.initState();
    isPaidAccount = widget.plan.toLowerCase() == "premium";
    _loadAccessibilityStatus();

    // Trigger validation when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //  hasUsernameBeenInteracted = true; // Trigger initial validation
      });
    });
  }

  // Function to load the accessibility status from shared preferences
  void _loadAccessibilityStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAccessibility = prefs.getString('accessibilityStatus') ??
          'None'; // Default to 'None' if not set
    });
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

  void _checkPasswordStrength(String value) {
    setState(() {
      isPasswordValid = _validatePassword(value) == null;
      hasPasswordBeenInteracted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wallpaper
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logPages/wall3.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Arrow button in top-left corner
          Positioned(
            top: 40, // Adjust top space
            left: 8, // Adjust left space
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                debugPrint("Back button pressed!");
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Navigate back once
                } else {
                  debugPrint("No route to pop");
                }
              },
            ),
          ),
          // Form Content inside SingleChildScrollView
          Positioned(
            top: 120, // Adjust top space to create margin from the top
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
                    Column(
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
                          "Sign up as Store Owner (${widget.plan})",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    const SizedBox(height: 20),
<<<<<<< HEAD
                    _buildTextField(
                      labelText: "First Name",
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty
                          ? "Please enter your first name"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Last Name",
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your last name" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "ُEmail",
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your Email" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) => value!.length < 8
                          ? "Password must be at least 8 characters"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Confirm Password",
                      icon: Icons.lock,
                      isPassword: true,
                      validator: (value) => value!.isEmpty
                          ? "Please confirm your password"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Date of Birth",
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
=======
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
>>>>>>> 9b4561b5e169e7bf87c457bcda79ed570ea1d7a4
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
                    // Accessibility Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Accessibility Status',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.accessibility,
                          color: AppColors.basicBackgroundColor,
                          size: 24,
                        ),
                      ),
                      value: selectedAccessibility,
                      items: [
                        'Colorblind',
                        'Blind',
                        'Low Vision',
                        'Elderly',
                        'None',
                      ].map((String accessibility) {
                        return DropdownMenuItem<String>(
                          value: accessibility,
                          child: Text(accessibility),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAccessibility = value;
                          // Save the selected value to SharedPreferences
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString(
                                'accessibilityStatus', value ?? 'None');
                          });
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your accessibility status';
                        }
                        return null;
                      },
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Collect form data
                            final username = _usernameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();
                            final condition = selectedAccessibility ?? 'None';

                            if (isPaidAccount) {
                              print("paidd");
                              // Navigate to the payment details page
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PaymentDetailsPage(
                              //       username: username,
                              //       email: email,
                              //       password: password,
                              //       condition: condition,
                              //       role: widget.role,
                              //       plan: widget.plan,
                              //     ),
                              //   ),
                              // );
                            } else {
                              // Free account: Proceed with signup
                              final result = await UserController().signup(
                                username: username,
                                email: email,
                                password: password,
                                confirmPassword: confirmPassword,
                                role: widget.role,
                                plan: widget.plan,
                                condition: condition,
                              );

                              // Handle signup result
                              setState(() {
                                errorMessage = result['message'];
                              });

                              if (result['success']) {
                                print("Signup successful!");
                              } else {
                                print("Signup failed: ${result['message']}");
                              }
                            }
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
                                color: const Color.fromARGB(100, 60, 172, 161),
                                offset: Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            constraints:
                                BoxConstraints(minWidth: 88, minHeight: 44),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.white, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  isPaidAccount ? "Next" : "Submit",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
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
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.basicBackgroundColor,
          size: 24,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
