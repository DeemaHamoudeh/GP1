import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'thirdWelcoming_page.dart';
import 'package:frontend/constants/colors.dart';

class SecondWelcomingPage extends StatefulWidget {
  const SecondWelcomingPage({super.key});

  @override
  _SecondWelcomingPageState createState() => _SecondWelcomingPageState();
}

class _SecondWelcomingPageState extends State<SecondWelcomingPage> {
  String? colorBlindType;

  @override
  void initState() {
    super.initState();
    _loadColorBlindType();
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly': // Reduced sensitivity to red
        return const ColorFilter.mode(
          Color(0xFFFFD1DC), // Light pink to enhance red
          BlendMode.modulate,
        );
      case 'deuteranomaly': // Reduced sensitivity to green
        return const ColorFilter.mode(
          Color(0xFFDAF7A6), // Light green to enhance green
          BlendMode.modulate,
        );
      case 'tritanomaly': // Reduced sensitivity to blue
        return const ColorFilter.mode(
          Color(0xFFA6E3FF), // Light cyan to enhance blue
          BlendMode.modulate,
        );
      case 'protanopia': // Red-blind
        return const ColorFilter.mode(
          Color(0xFFFFA07A), // Light salmon to compensate for red blindness
          BlendMode.modulate,
        );
      case 'deuteranopia': // Green-blind
        return const ColorFilter.mode(
          Color(0xFF98FB98), // Pale green to compensate for green blindness
          BlendMode.modulate,
        );
      case 'tritanopia': // Blue-blind
        return const ColorFilter.mode(
          Color(0xFFADD8E6), // Light blue to compensate for blue blindness
          BlendMode.modulate,
        );
      case 'achromatopsia': // Total color blindness
        return const ColorFilter.mode(
          Color(0xFFD3D3D3), // Light gray to provide neutral contrast
          BlendMode.modulate,
        );
      case 'achromatomaly': // Reduced total color sensitivity
        return const ColorFilter.mode(
          Color(0xFFEED5D2), // Light beige for better overall contrast
          BlendMode.modulate,
        );
      default:
        return const ColorFilter.mode(
          Colors.transparent, // No filter for 'none' or unrecognized type
          BlendMode.color,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return Scaffold(
      body: ColorFiltered(
        colorFilter: colorFilter,
        child: ListView(
          children: [
            // Container for the image
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/welcomingPages/manage.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Text below the image
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Effortlessly manage your products and track orders in one place!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Circle indicators for pages
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons for navigation
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the last welcoming page or home
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThirdWelcomingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.basicBackgroundColor,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
