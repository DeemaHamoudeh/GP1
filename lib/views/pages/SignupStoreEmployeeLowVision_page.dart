import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'jobPosts_page.dart';

class SignUpStoreEmployeeBlindPage extends StatefulWidget {
  const SignUpStoreEmployeeBlindPage({ Key? key})
      : super(key: key);

  @override
  State<SignUpStoreEmployeeBlindPage> createState() => _SignUpStoreEmployeeBlindPageState();
}

class _SignUpStoreEmployeeBlindPageState extends State<SignUpStoreEmployeeBlindPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _coverLetterController = TextEditingController();

  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _speechToText = stt.SpeechToText();
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
      Navigator.pop(context); // Close the confirmation message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobPostsPage()),
      );
    });
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
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> _listen(TextEditingController controller) async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => debugPrint("Speech status: $status"),
        onError: (error) => debugPrint("Speech error: $error"),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              controller.text = result.recognizedWords;
            });
          },
        );
      } else {
        debugPrint("Speech-to-text is not available.");
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
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
      onTap: () => _speak(labelText),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22, // Larger font for accessibility
                color: Colors.black,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.teal,
                size: 32, // Larger icon size
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.teal,
                  size: 32, // Larger icon size
                ),
                onPressed: () => _listen(controller),
              ),
            ),
            style: TextStyle(
              fontSize: 20, // Larger input text font
              color: Colors.black,
            ),
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
          // Wallpaper
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
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 36),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          // Form content
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
                    Text(
                      "Create new account (low vision Mode)",
                      style: const TextStyle(
                        fontSize: 36, // Larger title font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Sign up as Store Store Employee",
                      style: const TextStyle(
                        fontSize: 24, // Larger subtitle font size
                        color: Colors.grey,
                      ),
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
                      validator: (value) => value!.isEmpty
                          ? "Please write a cover letter"
                          : null,
                    ),
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.teal,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 28),
                            const SizedBox(width: 10),
                            Text("Submit"),
                          ],
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
