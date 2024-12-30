import 'package:flutter/material.dart';
import 'login_page.dart';

class PasswordResetSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3FF), // Light gray background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace the icon with an image
            Image.asset(
              'assets/images/logPages/check .png', // Path to your local image
              height: 130.0, // Set image height
              width: 130.0, // Set image width
            ),
            SizedBox(height: 40.0), // Space between the image and the card
            // White card with rounded corners
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // Card width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              padding: EdgeInsets.all(24.0), // Card content padding
              child: Column(
                mainAxisSize: MainAxisSize.min, // Make the card fit its content
                children: [
                  SizedBox(height: 30.0),
                  Text(
                    "Password Reset Successfully!",
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Your password has been changed successfully! ",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    " Please sign in to continue.",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.0), // Space between text and button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF11C9BF), // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
