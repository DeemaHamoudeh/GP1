import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firstWelcoming_page.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage>
    with TickerProviderStateMixin {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _showBottomPopUp();
    });
  }

  // Save selected status to SharedPreferences
  Future<void> _saveStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_status', status);
    debugPrint("User status saved: $status");
  }

  void _showBottomPopUp() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
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
                      onPressed: () async {
                        if (_selectedOption != null) {
                          // Save the selected option to SharedPreferences
                          await _saveStatus(_selectedOption!);

                          // Navigate to the next page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstWelcomingPage(),
                            ),
                          );
                        } else {
                          // Show an alert if no option is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select an option.")),
                          );
                        }
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
          setModalState(() {
            _selectedOption = newValue;
          });
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
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
