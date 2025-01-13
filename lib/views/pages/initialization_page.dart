import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashBoardStoreOwner_page.dart'; // Import the dashboard page
import 'login_page.dart'; // Import the login page

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Delay to ensure the splash screen is visible for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check for token and navigate accordingly
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Navigate to the dashboard if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardStoreOwnerPage(token: token),
        ),
      );
    } else {
      // Navigate to the login page if no token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcomingPages/StoreMaster.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
