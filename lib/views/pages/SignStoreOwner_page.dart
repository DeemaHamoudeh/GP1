import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:frontend/constants/colors.dart';
import 'choosePlan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool isPaidAccount = false;

  String? selectedAccessibility; // Variable to store selected accessibility

  @override
  void initState() {
    super.initState();
    isPaidAccount = widget.plan.toLowerCase() == "premium";
    _loadAccessibilityStatus();
  }

  // Function to load the accessibility status from shared preferences
  void _loadAccessibilityStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAccessibility = prefs.getString('accessibilityStatus') ??
          'None'; // Default to 'None' if not set
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
                    // const SizedBox(height: 20),
                    // _buildTextField(
                    //   labelText: "First Name",
                    //   icon: Icons.person,
                    //   validator: (value) => value!.isEmpty
                    //       ? "Please enter your first name"
                    //       : null,
                    // ),
                    // const SizedBox(height: 20),
                    // _buildTextField(
                    //   labelText: "Last Name",
                    //   icon: Icons.person_outline,
                    //   validator: (value) =>
                    //       value!.isEmpty ? "Please enter your last name" : null,
                    // ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "username",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your username" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "email",
                      icon: Icons.email,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your " : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) => value!.length < 6
                          ? "Password must be at least 6 characters"
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
                    // const SizedBox(height: 20),
                    // _buildTextField(
                    //   labelText: "Date of Birth",
                    //   icon: Icons.calendar_today,
                    //   keyboardType: TextInputType.datetime,
                    //   inputFormatters: [
                    //     FilteringTextInputFormatter.allow(RegExp(r'[0-9/.-]')),
                    //   ],
                    //   validator: (value) => value!.isEmpty
                    //       ? "Please enter your Date of Birth"
                    //       : null,
                    // ),
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

                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (isPaidAccount) {
                              debugPrint(
                                  "Proceed to Payment for ${widget.role} (${widget.plan} Plan)");
                            } else {
                              debugPrint(
                                  "Form Submitted for ${widget.role} (${widget.plan} Plan)");
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
