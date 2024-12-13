import 'package:flutter/material.dart';
import 'firstWelcoming_page.dart'; // Replace with your actual file name

class InitializationPage extends StatefulWidget {
  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds and then show the bottom pop-up window
    Future.delayed(Duration(seconds: 2), () {
      _showBottomPopUp();
    });
  }

  // Function to display the bottom pop-up window
  void _showBottomPopUp() {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // User cannot dismiss by tapping outside
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "What best describes you?", // Title text
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold, // Bold for emphasis
                  color: Color(0xFF00796B), // Vibrant teal color for contrast
                ),
              ),
              const SizedBox(height: 10), // Extra spacing after title
              // Subtitle
              const Text(
                "This will help us customize your experience.", // Subtitle text
                style: TextStyle(
                  fontSize: 16, // Slightly larger subtitle font
                  fontWeight: FontWeight.w400, // Regular weight for readability
                  color: Colors.black54, // Subtle color for secondary emphasis
                  height: 1.5, // Line height for better readability
                ),
              ),
              const SizedBox(height: 20), // Extra spacing after subtitle
              // Options with custom icons and radio buttons
              _buildOption("I am colorblind",
                  "assets/images/color-blind-icon.png", "colorblind"),
              _buildOption("I am elderly", "assets/images/old-woman-icon.png",
                  "elderly"),
              _buildOption("I have low vision",
                  "assets/images/low-vision-icon.png", "low_vision"),
              _buildOption("I am blind", "assets/images/hidden.png", "blind"),
              _buildOption("I don’t have any accessibility needs",
                  "assets/images/check.png", "none"),
              // const SizedBox(height: 16),
              // Centered Confirmation button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirstWelcomingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF33B5AB), // Your teal color
                    elevation: 3, // Add slight shadow for depth
                    padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12), // Add padding for better button size
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 18, // Slightly larger button text
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget for building options
  Widget _buildOption(String label, dynamic icon, String value) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0), // Add consistent spacing
      leading: icon is String
          ? SizedBox(
              width: 30, // Larger width for custom image
              height: 30, // Larger height for custom image
              child: Image.asset(
                icon,
                fit: BoxFit.contain, // Ensures the image scales well
              ),
            )
          : Icon(icon, color: Color(0xFF33B5AB)), // Match the teal theme
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18, // Set the font size here
        ),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: null, // Replace with a state variable if needed
        onChanged: (String? newValue) {
          // Handle selection
          print("Selected: $newValue");
        },
      ),
    );
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
