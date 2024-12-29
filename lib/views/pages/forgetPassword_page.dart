import 'package:flutter/material.dart';
import 'verifyEmail_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center child widgets
          children: [
            Center(
              child: Container(
                width: 200, // Smaller size for the circle
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100, // Lighter teal background
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      30.0), // Optional padding inside the circle
                  child: Image.asset(
                    'assets/images/logPages/forgot-password (2).png', // Replace with your image path
                    fit: BoxFit.fill, // Ensures the image fits within its space
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Please enter your email address to receive a verification code.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 80),
            // Text(
            //   'Email Address',
            //   textAlign: TextAlign.left,
            //   style: TextStyle(fontSize: 18),
            // ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25), // Rounded borders
                ),
              ),
            ),
            SizedBox(height: 160),
            // Wrapping the button in a Center widget
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyEmailPage()),
                  );
                },
                child: Text(
                  "Send",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50), // Button size (width, height)
                  backgroundColor: Colors.teal, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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
