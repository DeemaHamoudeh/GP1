import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'secondWelcoming_page.dart';
import 'package:frontend/constants/colors.dart';

class FirstWelcomingPage extends StatefulWidget {
  const FirstWelcomingPage({super.key});

  @override
  State<FirstWelcomingPage> createState() => _FirstWelcomingPageState();
}

class _FirstWelcomingPageState extends State<FirstWelcomingPage> {
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
        colorFilter: colorFilter, // Apply the color filter
        child: ListView(
          children: [
            // Container for the image
            Container(
              height: MediaQuery.of(context).size.height *
                  0.6, // 60% of the screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/welcomingPages/buildApp.png'),
                  fit: BoxFit.fill, // Ensures the image covers the container
                ),
              ),
            ),

            // Text below the image
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Personalize your shop to reflect your brand identity.',
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
                  // First circle (filled)
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal, // Filled color for the active page
                    ),
                  ),

                  // Second circle (unfilled)
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey, // Grey for inactive pages
                    ),
                  ),

                  // Third circle (unfilled)
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey, // Grey for inactive pages
                    ),
                  ),
                ],
              ),
            ),

            // Buttons for navigation
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button (as plain text)
                  GestureDetector(
                    onTap: () {
                      // Navigate to the last welcoming page or home
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),

                  // Next Button (circular with arrow icon)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondWelcomingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), // Circular button
                      backgroundColor:
                          AppColors.basicBackgroundColor, // Background color
                      padding: const EdgeInsets.all(
                          16), // Add padding to make it circular
                    ),
                    child: const Icon(
                      Icons.arrow_forward, // Right arrow icon
                      color: Colors.white, // Icon color
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
