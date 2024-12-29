import 'package:flutter/material.dart';

class CreatePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Password')),
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
                      'assets/images/logPages/correctPassword.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your new password must be different from previously used passwords.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.teal, // Teal color when focused
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.teal, // Teal color when focused
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // Add your logic here
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
