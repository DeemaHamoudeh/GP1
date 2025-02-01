import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'storeEmployeeconfirm_page.dart'; // Import your confirmation page
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<void> requestMicrophonePermission() async {
  await Permission.microphone.request();
}

class SignUpStoreEmployeeBlindPage extends StatefulWidget {
  const SignUpStoreEmployeeBlindPage({Key? key}) : super(key: key);

  @override
  State<SignUpStoreEmployeeBlindPage> createState() =>
      _SignUpStoreEmployeeBlindPageState();
}

class _SignUpStoreEmployeeBlindPageState
    extends State<SignUpStoreEmployeeBlindPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
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
  TextEditingController? _currentController;
  File? _selectedFile;

  final List<String> _jobPositions = [
    "order management",
    "products management",
    "delivary management",
    "Report & Analytics",
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
    requestMicrophonePermission();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _usernameController.dispose();
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
    if (await Permission.microphone.isGranted) {
      final available = await _speechToText.initialize(
        onStatus: (status) => debugPrint("Speech status: $status"),
        onError: (error) => debugPrint("Speech error: $error"),
      );

      if (available) {
        setState(() {
          _isListening = true;
          _currentController = controller;
        });
        _speechToText.listen(onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        });
      } else {
        await _speak("Speech recognition is unavailable.");
      }
    } else {
      await _speak("Please grant microphone permission.");
    }
  }
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate() &&
        _selectedJobPosition != null &&
        _coverLetterController.text.isNotEmpty) {
      // Ensure the message is read before navigating
      await _speak("Application submitted successfully.");
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmployeeConfirmWait()),
      );
    } else {
      await _speak("Failed to submit application. Please fill all fields.");
    }
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return GestureDetector(
      onTap: () async {
        await _speak(labelText);
        if (labelText == "userame") {
          await Future.delayed(const Duration(seconds: 2));
          controller.text = "Ahmed";
        } else if (labelText == "Phone Number") {
          await Future.delayed(const Duration(seconds: 5));
          controller.text = "0597373534";
        }
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
                  _isListening && _currentController == controller
                      ? Icons.mic
                      : Icons.mic_none,
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
    return GestureDetector(
      onTap: () async {
        await _speak("Start filling the form ");
        await Future.delayed(const Duration(seconds: 2));
        await _speak("username");
        await Future.delayed(const Duration(seconds: 4));
        await _speak("phone number");
        await Future.delayed(const Duration(seconds: 6));
        await _speak("email");
        await Future.delayed(const Duration(seconds: 9));
        await _speak("password");
        await Future.delayed(const Duration(seconds: 9));
        await _speak("confirm password");
        await Future.delayed(const Duration(seconds: 9));
        await _speak("Store Name");
        await Future.delayed(const Duration(seconds: 7));
        await _speak("Select Job Position");
        await Future.delayed(const Duration(seconds: 7));
        await _speak("write your cover letter");
        await Future.delayed(const Duration(seconds: 20));
      },
      child: Scaffold(
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
                        "Sign up as Store Employee",
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                      _buildTextField(
                        labelText: "userame",
                        icon: Icons.person,
                        controller: _usernameController,

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
                       GestureDetector(
                        onTap: () => _speak("Store Name"),
                      child: _buildTextField(
                        labelText: "Store Name",
                        icon: Icons.store,
                        controller: _storeIDController,
                      ),
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
                            labelStyle: const TextStyle(
                                fontSize: 22, color: Colors.black),
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
                          onPressed: _submitApplication,
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
      ),
    );
  }
}
