import 'package:flutter/material.dart';
import 'firstWelcoming_page.dart'; // Replace with your actual file name

class InitializationPage extends StatefulWidget {
  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage>
    with TickerProviderStateMixin {
  // Variable to hold the selected value for the radio button group
  String? _selectedOption;

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
      isDismissible: false,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      transitionAnimationController: AnimationController(
        vsync: this, // This is required to control the animation
        duration: Duration(milliseconds: 500), // Adjust animation duration here
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add StatefulBuilder to manage state within the modal sheet
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What best describes you?",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00796B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This will help us customize your experience.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionWithState(
                    "I am colorblind",
                    "assets/images/color-blind-icon.png",
                    "colorblind",
                    setModalState,
                  ),
                  _buildOptionWithState(
                    "I am elderly",
                    "assets/images/old-woman-icon.png",
                    "elderly",
                    setModalState,
                  ),
                  _buildOptionWithState(
                    "I have low vision",
                    "assets/images/low-vision-icon.png",
                    "low_vision",
                    setModalState,
                  ),
                  _buildOptionWithState(
                    "I am blind",
                    "assets/images/hidden.png",
                    "blind",
                    setModalState,
                  ),
                  _buildOptionWithState(
                    "I don’t have any accessibility needs",
                    "assets/images/check.png",
                    "none",
                    setModalState,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstWelcomingPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF33B5AB),
                        elevation: 3,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 18,
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
      },
    );
  }

  // Widget for building options
  Widget _buildOptionWithState(
      String label, dynamic icon, String value, StateSetter setModalState) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0),
      leading: icon is String
          ? SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                icon,
                fit: BoxFit.contain,
              ),
            )
          : Icon(icon, color: Color(0xFF33B5AB)),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedOption,
        onChanged: (String? newValue) {
          // Use setModalState to rebuild the modal UI
          setModalState(() {
            _selectedOption = newValue;
          });
          // Optional: Also call the main setState for other tracking
          setState(() {
            _selectedOption = newValue;
          });
          debugPrint("Selected: $newValue");
        },
        activeColor: Color(0xFF33B5AB),
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
