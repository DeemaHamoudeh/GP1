import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests

class DashboardStoreOwnerPage extends StatefulWidget {
  final String? token;

  const DashboardStoreOwnerPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<DashboardStoreOwnerPage> createState() =>
      _DashboardStoreOwnerPageState();
}

class _DashboardStoreOwnerPageState extends State<DashboardStoreOwnerPage> {
  String? userName; // Placeholder for the user's name
  bool isLoading = true; // To show loading indicator while fetching data
  String baseUrl =
      "http://your-backend-url.com/api"; // Replace with your backend URL

  // List of setup guide steps
  List<Map<String, dynamic>> steps = [
    {"title": "Name your product", "isCompleted": false},
    {"title": "Add your product", "isCompleted": false},
    {"title": "Customize your online store", "isCompleted": true},
    {"title": "Add pages to your store", "isCompleted": false},
    {"title": "Organize navigation", "isCompleted": false},
    {"title": "Shipment and Delivery", "isCompleted": false},
    {"title": "Payment", "isCompleted": false},
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name during initialization
  }

  Future<void> _fetchUserName() async {
    if (widget.token == null) {
      setState(() {
        userName = "Guest";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user-info"), // Replace with your endpoint
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          userName =
              responseData['name']; // Assuming the API returns a 'name' field
          isLoading = false;
        });
      } else {
        print("Failed to fetch user info: ${response.statusCode}");
        setState(() {
          userName = "User"; // Fallback name
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching user info: $error");
      setState(() {
        userName = "User"; // Fallback name
        isLoading = false;
      });
    }
  }

  // Calculate progress based on completed steps
  double _calculateProgress() {
    int completedSteps =
        steps.where((step) => step["isCompleted"] == true).length;
    return completedSteps / steps.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // Top Bar with Sidebar and Notification Icons
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle sidebar open
                        print("Sidebar icon tapped");
                      },
                      child: Icon(Icons.menu,
                          size: 28,
                          color: const Color.fromARGB(255, 90, 193, 184)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle notifications
                        print("Notification icon tapped");
                      },
                      child: Icon(Icons.notifications,
                          size: 28,
                          color: const Color.fromARGB(255, 90, 193, 184)),
                    ),
                  ],
                ),
              ),

              // Greeting Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? CircularProgressIndicator() // Show loader while fetching data
                        : Text(
                            'Hello, user!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    SizedBox(height: 8),
                    Text(
                      "You're one step closer to launching your store!",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Tracker Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  elevation: 4, // Adds shadow to the card
                  color: const Color.fromARGB(255, 90, 193, 184),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Circular Progress Indicator
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: CircularProgressIndicator(
                                value:
                                    _calculateProgress(), // Dynamic progress value
                                backgroundColor:
                                    const Color.fromARGB(255, 201, 215, 214),
                                color: Colors.white,
                                strokeWidth: 14,
                              ),
                            ),
                            Text(
                              '${(_calculateProgress() * steps.length).round()}/${steps.length}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Progress Description
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _calculateProgress() > 0
                                      ? 'Great Job!'
                                      : 'Let\'s Get Started!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _calculateProgress() > 0
                                      ? 'You’ve completed ${(_calculateProgress() * steps.length).round()} out of ${steps.length} tasks. Keep going!'
                                      : 'Complete your first task to begin your journey.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 35),

              // Setup Guide Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Setup Guide",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.teal.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: steps
                          .asMap()
                          .entries
                          .map((entry) => Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      entry.value["isCompleted"]
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: entry.value["isCompleted"]
                                          ? Colors.teal
                                          : Colors.grey,
                                    ),
                                    title: Text(
                                      entry.value["title"],
                                      style: TextStyle(
                                        color: entry.value["isCompleted"]
                                            ? Colors.teal
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(Icons.arrow_forward,
                                        color: Colors.teal),
                                    onTap: () {
                                      setState(() {
                                        entry.value["isCompleted"] =
                                            !entry.value["isCompleted"];
                                      });
                                    },
                                  ),
                                  if (entry.key != steps.length - 1)
                                    Divider(color: Colors.grey[300]),
                                ],
                              ))
                          .toList(),
                    ),
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
