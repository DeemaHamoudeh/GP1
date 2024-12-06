import 'package:flutter/material.dart';
import 'firstWelcoming_page.dart'; // Replace with the actual file name of your welcoming page

class InitializationPage extends StatefulWidget {
  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds and then navigate to the first welcoming page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstWelcomingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/StoreMaster.png'),
            fit: BoxFit.fill, // Adjust the image size to cover the screen
          ),
        ),
      ),
    );
  }
}
