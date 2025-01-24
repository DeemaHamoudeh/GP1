import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'jobPosts_page.dart';

class SignUpStoreEmployeeElderlyPage extends StatefulWidget {
  const SignUpStoreEmployeeElderlyPage({super.key});

  @override
  State<SignUpStoreEmployeeElderlyPage> createState() =>
      _SignUpStoreEmployeeElderlyPageState();
}

class _SignUpStoreEmployeeElderlyPageState
    extends State<SignUpStoreEmployeeElderlyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _coverLetterController = TextEditingController();

  // List of job positions
  final List<String> _jobPositions = [
    'Inventory Manager',
    'Customer Service',
    'Stock Associate',
    'Sales Assistant',
    'Shift Supervisor',
  ];

  String? _selectedJobPosition; // Variable to hold the selected position

  void _showConfirmationMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text(
          "Your information has been submitted successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close the confirmation message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobPostsPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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
          // Back button
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
          // Form content
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
                    const Text(
                      "Sign Up as Store Employee (Elderly)",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "First Name",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your first name" : null,
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
                      labelText: "Email",
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your Email" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Phone",
                      icon: Icons.phone_android_outlined,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your Phone Number" : null,
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
                      validator: (value) =>
                          value!.isEmpty ? "Please confirm your password" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: "Store ID you what to apply for",
                      icon: Icons.lock,
                      validator: (value) => value!.length < 5
                          ? "please enter Store ID (it should be 5 numbers)"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Job Position",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: _jobPositions.map((String position) {
                        return DropdownMenuItem<String>(
                          value: position,
                          child: Text(position),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedJobPosition = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a job position" : null,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Cover Letter",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _coverLetterController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: "Write your cover letter here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please write a cover letter" : null,
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmationMessage();
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
                              WidgetStateProperty.all(Colors.transparent),
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
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(100, 60, 172, 161),
                                offset: Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            constraints:
                                const BoxConstraints(minWidth: 88, minHeight: 44),
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
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(icon),
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }
}
