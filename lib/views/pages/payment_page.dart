import 'package:flutter/material.dart';
import 'package:frontend/controllers/userController.dart';

class PaymentPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String condition;
  final String typecolorblind;
  final String firstSecurityQuestion;
  final String secondSecurityQuestion;
  final String thirdSecurityQuestion;
  final String role;
  final String plan;

  const PaymentPage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.condition,
    required this.typecolorblind,
    required this.firstSecurityQuestion,
    required this.secondSecurityQuestion,
    required this.thirdSecurityQuestion,
    required this.role,
    required this.plan,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedOption = ""; // Tracks selected payment method
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom back button
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
              ),
            ),
            // Progress Tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Personal Details",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 2,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.payment, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Payment Details",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            // Payment Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Payment Method:",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = "PayPal";
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _selectedOption == "PayPal"
                          ? Colors.teal
                          : const Color.fromARGB(255, 224, 223, 223),
                      width: 2,
                    ),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    minimumSize: Size(170, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logPages/paypal.png',
                        width: 90,
                        height: 40,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = "CreditCard";
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _selectedOption == "CreditCard"
                          ? Colors.teal
                          : const Color.fromARGB(255, 224, 223, 223),
                      width: 2,
                    ),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    minimumSize: Size(170, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logPages/credit-card (1).png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Credit card",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 16,
                            fontWeight: _selectedOption == "CreditCard"
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            if (_selectedOption == "PayPal") _buildPayPalForm(),
            if (_selectedOption == "CreditCard") _buildCreditCardForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PayPal Payment",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "PayPal Email",
              labelStyle: TextStyle(color: Colors.grey[700]),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await UserController().signup(
                  username: widget.username,
                  email: widget.email,
                  password: widget.password,
                  confirmPassword: widget.confirmPassword,
                  role: widget.role,
                  plan: widget.plan,
                  condition: widget.condition,
                  typecolorblind: widget.typecolorblind,
                  firstSecurityQuestion: widget.firstSecurityQuestion,
                  secondSecurityQuestion: widget.secondSecurityQuestion,
                  thirdSecurityQuestion: widget.thirdSecurityQuestion,
                  paymentMethod: "PayPal",
                  paypalEmail: _emailController.text,
                );

                if (!result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? "Payment failed."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Pay Now",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Credit Card details:",
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Card Number",
              labelStyle: TextStyle(color: Colors.grey[700]),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Exp Date",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[300]!, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "CVV",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[300]!, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle Credit Card payment logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Pay Now",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}