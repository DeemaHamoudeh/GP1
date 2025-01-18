import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'StoreOwner/dashBoardStoreOwner_page.dart'; // Import the dashboard page
import 'firstWelcoming_page.dart';
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
    // تأخير الشاشة الافتتاحية لمدة 3 ثوانٍ
    await Future.delayed(const Duration(seconds: 3));

    // الحصول على SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // التحقق إذا كان التطبيق يفتح لأول مرة
    bool? isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // إذا كانت هذه أول مرة
      await prefs.setBool(
          'isFirstTime', false); // تعيينه إلى false بعد الدخول لأول مرة
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstWelcomingPage()),
      );
    } else {
      // التحقق إذا كان هناك توكين (token) للدخول إلى الداشبورد مباشرة
      String? token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardStoreOwnerPage(token: token),
          ),
        );
      } else {
        // إذا لم يكن هناك توكين، توجيهه إلى صفحة تسجيل الدخول
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
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
