import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'storeEmployeeconfirm_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> requestMicrophonePermission() async {
  await Permission.microphone.request();
}

class SignUpStoreEmployeeBlindPage extends StatefulWidget {
  const SignUpStoreEmployeeBlindPage({super.key});

  @override
  State<SignUpStoreEmployeeBlindPage> createState() =>
      _SignUpStoreEmployeeBlindPageState();
}

class _SignUpStoreEmployeeBlindPageState
    extends State<SignUpStoreEmployeeBlindPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _storeIDController = TextEditingController();
  final _coverLetterController = TextEditingController();
  String? _selectedJobPosition;

  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  final List<String> _jobPositions = [
    "Inventory Manager",
    "Customer Service Representative",
    "Sales Associate",
    "Store Manager",
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US"); // Set language
    _flutterTts.setSpeechRate(0.5);   // Adjust speech rate
    _flutterTts.setVolume(1.0);       // Set volume
    _flutterTts.setPitch(1.0);        // Set pitch
    _speechToText = stt.SpeechToText();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _storeIDController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> _listen(TextEditingController controller) async {
    final available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords;
        });
      });
    } else {
      await _speak("Speech recognition is unavailable.");
    }
  }

  Future<void> _submitApplication() async {
    final url = Uri.parse('mongodb://localhost:27017/StoreMaster/apply');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'applicantName':
              '${_firstnameController.text} ${_lastnameController.text}',
          'jobPosition': _selectedJobPosition,
          'storeOwnerId': _storeIDController.text,
          'coverLetter': _coverLetterController.text,
        }),
      );

      if (response.statusCode == 201) {
        await _speak("Application submitted successfully.");
        _showConfirmationMessage();
      } else {
        await _speak("Failed to submit application. Please try again.");
        print("Error: ${response.body}");
      }
    } catch (e) {
      await _speak("An error occurred while submitting your application.");
      print("Exception: $e");
    }
  }

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
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeConfirmWait()),
      );
    });
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return GestureDetector(
      onTap: () {
        print("Tapped on: $labelText"); // Debugging to confirm tap is registered
        _speak(labelText);
      },
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(fontSize: 22, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(icon, color: Colors.teal, size: 32),
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.teal,
                  size: 32,
                ),
                onPressed: () => _listen(controller),
              ),
            ),
            style: const TextStyle(fontSize: 20, color: Colors.black),
            keyboardType: keyboardType,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 36),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            bottom: 16,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create new account (low vision Mode)",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Sign up as Store Store Employee",
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      labelText: "First Name",
                      icon: Icons.person,
                      controller: _firstnameController,
                    ),
                    _buildTextField(
                      labelText: "Last Name",
                      icon: Icons.person,
                      controller: _lastnameController,
                    ),
                    _buildTextField(
                      labelText: "Phone Number",
                      icon: Icons.phone,
                      controller: _phonenumberController,
                    ),
                    _buildTextField(
                      labelText: "Email",
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      labelText: "Password",
                      icon: Icons.lock,
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    _buildTextField(
                      labelText: "Confirm Password",
                      icon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                      isPassword: true,
                    ),
                    _buildTextField(
                      labelText: "Store ID",
                      icon: Icons.store,
                      controller: _storeIDController,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _speak("Select Job Position"),
                      child: DropdownButtonFormField<String>(
                        value: _selectedJobPosition,
                        items: _jobPositions
                            .map((position) => DropdownMenuItem(
                                  value: position,
                                  child: Text(position),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedJobPosition = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Job Position",
                          labelStyle:
                              const TextStyle(fontSize: 22, color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      labelText: "Cover Letter",
                      icon: Icons.edit,
                      controller: _coverLetterController,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedJobPosition == null) {
                              _speak("Please select a job position.");
                              return;
                            }
                            _submitApplication();
                          } else {
                            _speak("Please fill in all fields correctly.");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
}
