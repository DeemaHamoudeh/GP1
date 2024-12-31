import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choosePlan_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String selectedRole = "";
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

  Widget roleBox(String title, String imagePath) {
    bool isSelected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
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
                        if (selectedRole == "Store Owner") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  choosePlanPage(role: selectedRole),
                            ),
                          );
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
