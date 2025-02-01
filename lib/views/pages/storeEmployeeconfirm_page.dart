import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'login_page.dart';

class EmployeeConfirmWait extends StatelessWidget {
  const EmployeeConfirmWait({super.key});

  Future<void> _speak(String text) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          await _speak(
              "Please wait for the store owner to confirm your request, and then try logging in again.");
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Color(0xFFB2DFDB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/logPages/wall3.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 70.0, left: 30.0, right: 30.0, bottom: 30.0,
                  ),
                  child: Text(
                    "StoreMaster",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Please wait for the store owner to confirm your request!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
