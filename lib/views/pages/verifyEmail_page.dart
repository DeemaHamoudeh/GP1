import 'package:flutter/material.dart';
import 'createNewPassword.dart';
import '../../../controllers/userController.dart'; // Import UserController

class VerifyEmailPage extends StatefulWidget {
  final String email; // Receive email as a parameter

  VerifyEmailPage({required this.email}); // Constructor to accept email

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // List to store FocusNode for each text field
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  // TextControllers to get text from text fields
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    // Dispose the focus nodes and text controllers when the widget is disposed
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to call verifyPin and show a result
  void _verifyPin() async {
    // Combine the 4 entered digits into a single string
    String pinCode = controllers.map((controller) => controller.text).join();

    // Check if all the fields are filled
    if (pinCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a 4-digit code.')),
      );
      return;
    }

    // Get the email from the previous screen or however you store it
    String email = widget.email;

    // Call the verifyPin function
    var result = await UserController().verifyPin(email, pinCode);

    // Check if verification was successful
    if (result['success']) {
      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreatePasswordPage(email: email, pin: pinCode)),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to verify PIN')),
      );
    }
  }

  // Function to handle Resend Code
  void _resendCode() async {
    String email = widget.email;

    // Call the sendEmail function to resend the code
    var result = await UserController().sendEmail(email);

    // Show feedback based on result
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code resent successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to resend code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Your Email')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset(
                      'assets/images/logPages/letter (1).png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Please enter the 4-digit code sent to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 4; i++)
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: controllers[i], // Set the controller
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNodes[i],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal, // Teal color when focused
                              width: 3.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 130),
              ElevatedButton(
                onPressed: _verifyPin, // Call the function when pressed
                child: Text(
                  'Verify',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              TextButton(
                onPressed:
                    _resendCode, // Call resend code function when pressed
                child: Text(
                  'Resend Code',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
