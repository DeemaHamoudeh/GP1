import 'package:flutter/material.dart';
import 'createNewPassword.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // List to store FocusNode for each text field
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    // Dispose the focus nodes when the widget is disposed
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode:
                            focusNodes[i], // Attach focusNode to each TextField
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal, // Teal color when focused
                              width: 3.0,
                            ),
                          ),
                          //  border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 130),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePasswordPage()),
                  );
                },
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
                onPressed: () {},
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
