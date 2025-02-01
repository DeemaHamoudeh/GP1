import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choosePlan_page.dart';

import 'SignUpStoreEmployeeElderly_page.dart';
import 'SignUpStoreEmployeecolorblind_Normal_page.dart ';
import 'SignupStoreEmployeeLowVision_page.dart';

import 'SignUpStaffcolorblind_Normal_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String selectedRole = "";
  String? colorBlindType;
  String? userStatus;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadColorBlindType();
    _loadUserStatus();
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  Future<void> _loadUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStatus = prefs.getString('user_status') ?? 'none';
    });
    debugPrint("User status loaded: $userStatus");
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly':
        return const ColorFilter.mode(
          Color(0xFFFFD1DC),
          BlendMode.modulate,
        );
      case 'deuteranomaly':
        return const ColorFilter.mode(
          Color(0xFFDAF7A6),
          BlendMode.modulate,
        );
      case 'tritanomaly':
        return const ColorFilter.mode(
          Color(0xFFA6E3FF),
          BlendMode.modulate,
        );
      case 'protanopia':
        return const ColorFilter.mode(
          Color(0xFFFFA07A),
          BlendMode.modulate,
        );
      case 'deuteranopia':
        return const ColorFilter.mode(
          Color(0xFF98FB98),
          BlendMode.modulate,
        );
      case 'tritanopia':
        return const ColorFilter.mode(
          Color(0xFFADD8E6),
          BlendMode.modulate,
        );
      case 'achromatopsia':
        return const ColorFilter.mode(
          Color(0xFFD3D3D3),
          BlendMode.modulate,
        );
      case 'achromatomaly':
        return const ColorFilter.mode(
          Color(0xFFEED5D2),
          BlendMode.modulate,
        );
      default:
        return const ColorFilter.mode(
          Colors.transparent,
          BlendMode.color,
        );
    }
  }

  Widget roleBox(String title, String imagePath) {
    bool isSelected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
        _speak("$title selected");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
              color: isSelected ? Colors.teal : null,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.teal : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return Scaffold(
      body: ColorFiltered(
        colorFilter: colorFilter,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 20,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Select Your Account Type",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        roleBox("Store Owner",
                            "assets/images/logPages/owner-icon.png"),
                        roleBox("Customer",
                            "assets/images/logPages/customer-icon.png"),
                        roleBox("Store Employee",
                            "assets/images/logPages/employee-icon.png"),
                        roleBox("Staff",
                            "assets/images/logPages/staff-icon.png"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: selectedRole.isNotEmpty
                    ? () {
                        _speak("Role selected");
                        if (selectedRole == "Store Owner") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  choosePlanPage(role: selectedRole),
                            ),
                          );
                        } else if (selectedRole == "Store Employee") {
                          if (userStatus == 'elderly') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUpStoreEmployeeElderlyPage(),
                              ),
                            );
                          } else if (userStatus == 'colorblind' ||
                              userStatus == 'none') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUpStoreStoreEmployeeColorBlindNormalPage(),
                              ),
                            );
                          } else if (userStatus == 'low_vision') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUpStoreEmployeeBlindPage(),

                              ),
                            );
                          }
                        } else if (selectedRole == "Staff") {
                          if (userStatus == 'colorblind' ||
                              userStatus == 'none') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUpStaffColorBlindNormalPage(),
                              ),
                            );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: selectedRole.isNotEmpty ? 5 : 0,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
