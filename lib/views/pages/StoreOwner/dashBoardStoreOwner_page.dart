import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import '../../../../controllers/userController.dart'; // Import UserController
import '../login_page.dart'; // Import the login page
import 'storeDetails_page.dart';
import 'addProduct_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? token;
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
    token = widget.token;
    print("Received Token: ${widget.token}");
    _fetchUserInfo(); // Fetch the user's name during initialization
    _fetchSetupGuide();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSetupGuide();
    });
  }

  Future<void> _fetchSetupGuide() async {
    print("🛠️ Fetching Setup Guide");
    if (token == null || token!.isEmpty) {
      print("❌ Token is missing.");
      return;
    }

    try {
      final userController = UserController();
      final result = await userController.fetchSetupGuide(token!);

      if (result['success']) {
        print("✅ Setup Guide fetched successfully.");

        setState(() {
          steps = List<Map<String, dynamic>>.from(result['data']);
        });

        print("🔄 Updated steps: $steps");
      } else {
        print('❌ Failed to fetch setup guide: ${result['message']}');
      }
    } catch (error) {
      print("❌ Error fetching setup guide: $error");
    }
  }

  Future<void> _fetchUserInfo() async {
    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {
        userName = "Guest";
        isLoading = false;
      });
      return;
    }

    try {
      final userController =
          UserController(); // Create an instance of the controller
      final result = await userController.fetchUserInfo(widget.token!);

      if (result['success']) {
        setState(() {
          userName =
              result['data']['username']; // Replace with the correct field
          isLoading = false;
        });
      } else {
        print('Failed to fetch user info: ${result['message']}');
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

  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token
    await prefs.setBool('isFirstTime', true);
    print("User logged out: Token removed from SharedPreferences");
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.teal.shade700, Colors.teal.shade300],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: const Color.fromARGB(255, 93, 171, 164),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Section
            SizedBox(height: 10),
            SizedBox(
              height: 120, // Adjust the height here
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Match with gradient
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.store, size: 40, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'StoreMaster',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Menu Items
            _buildMenuItem(Icons.home, 'Home', context),
            SizedBox(height: 30),
            ExpansionTile(
              leading:
                  Icon(Icons.shopping_bag, color: Colors.grey[100], size: 33),
              title: Text(
                'Orders',
                style: TextStyle(color: Colors.grey[100], fontSize: 20),
              ),
              childrenPadding: EdgeInsets.only(left: 50.0),
              children: [
                _buildSubMenuItem('Drafts', context),
              ],
            ),
            SizedBox(height: 30),
            ExpansionTile(
              leading: Icon(Icons.production_quantity_limits,
                  color: Colors.grey[100], size: 33),
              title: Text(
                'Products',
                style: TextStyle(color: Colors.grey[100], fontSize: 20),
              ),
              childrenPadding: EdgeInsets.only(left: 50.0),
              children: [
                _buildSubMenuItem('Inventory', context),
              ],
            ),
            SizedBox(height: 30),
            _buildMenuItem(Icons.analytics, 'Analytics', context),
            SizedBox(height: 30),
            ExpansionTile(
              leading: Icon(Icons.store, color: Colors.grey[100], size: 33),
              title: Text(
                'Online Store',
                style: TextStyle(color: Colors.grey[100], fontSize: 20),
              ),
              childrenPadding: EdgeInsets.only(left: 50.0),
              children: [
                _buildSubMenuItem('Themes', context),
                _buildSubMenuItem('Pages', context),
                _buildSubMenuItem('Navigation', context),
              ],
            ),
            SizedBox(height: 30),
            ExpansionTile(
              leading: Icon(Icons.settings, color: Colors.grey[100], size: 33),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.grey[100], fontSize: 20),
              ),
              childrenPadding: EdgeInsets.only(left: 50.0),
              children: [
                ListTile(
                  title: Text(
                    'Store Details',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ), // Close the drawer
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreDetailsPage(token: token)),
                    );

                    if (result != null) {
                      print("🔄 Returning to Dashboard, result: $result");

                      setState(() {
                        if (result is String) {
                          token = result; // ✅ Update token
                        }
                      });

                      _fetchSetupGuide(); // ✅ Reload setup guide
                    } else {
                      print(
                          "⚠️ No result returned, _fetchSetupGuide() will not be called.");
                    }
                  },
                ),
                _buildSubMenuItem('Payment', context),
                _buildSubMenuItem('Checkout', context),
                _buildSubMenuItem('Shipping and Delivery', context),
              ],
            ),
            SizedBox(height: 30),
            // Footer Section
            Divider(color: Colors.white.withOpacity(0.5)),

            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[300], size: 33),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.grey[300], fontSize: 20),
              ),
              onTap: () async {
                await _logoutUser(); // Call the logout function
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), // Navigate to LoginPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }

// Helper to build main menu item
  Widget _buildMenuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[100],
        size: 33,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.grey[100], fontSize: 20),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        // Handle navigation logic
      },
    );
  }

// Helper to build sub-menu item
  Widget _buildSubMenuItem(String title, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        // Handle navigation logic
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(context), // Add the drawer here
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,
                color: const Color.fromARGB(255, 90, 193, 184)),
            onPressed: () =>
                Scaffold.of(context).openDrawer(), // Open the drawer
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,
                color: const Color.fromARGB(255, 90, 193, 184)),
            onPressed: () {
              // Handle notifications
              print("Notification icon tapped");
            },
          ),
        ],
      ),
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
              SizedBox(height: 0),
              // Greeting Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? CircularProgressIndicator() // Show loader while fetching data
                        : Text(
                            'Hello, ${userName ?? "user"}!',
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
                      children: steps.isNotEmpty //
                          ? steps.map((step) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      step["isCompleted"]
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: step["isCompleted"]
                                          ? Colors.teal
                                          : Colors.grey,
                                    ),
                                    title: Text(
                                      step["title"] ?? "Untitled Step",
                                      style: TextStyle(
                                        color: step["isCompleted"]
                                            ? Colors.teal
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(Icons.arrow_forward,
                                        color: Colors.teal),
                                    onTap: () async {
                                      if (step["title"] ==
                                          "Name your product") {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoreDetailsPage(
                                                    token: widget.token),
                                          ),
                                        );

                                        if (result == true) {
                                          print(
                                              "🔄 Reloading setup guide after store update...");
                                          _fetchSetupGuide(); // ✅ إعادة تحميل البيانات بعد التحديث
                                        }
                                      } else if (step["title"] ==
                                          "Add your product") {
                                        // ✅ Second Step: Navigate to Add Product Page
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddProductPage(), // ✅ Navigate to Add Product Page
                                          ),
                                        );

                                        if (result == true) {
                                          print(
                                              "🔄 Reloading setup guide after adding product...");
                                          _fetchSetupGuide(); // ✅ Reload setup guide after returning
                                        }
                                      } else {
                                        // ✅ Default behavior for other steps (optional)
                                        print(
                                            "No specific navigation for this step.");
                                      }
                                    },
                                  ),
                                  Divider(color: Colors.grey[300]),
                                ],
                              );
                            }).toList()
                          : [
                              Text("No setup guide found")
                            ], // ✅ عرض رسالة إذا لم تكن هناك خطوات
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
