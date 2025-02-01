import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productManagement_page.dart';
import 'orderManagement_page.dart';
import 'report_page.dart';

class PostLaunchDashboard extends StatefulWidget {
  final String? token;

  PostLaunchDashboard({Key? key, required this.token}) : super(key: key);

  @override
  _PostLaunchDashboardState createState() => _PostLaunchDashboardState();
}

class _PostLaunchDashboardState extends State<PostLaunchDashboard> {
  int notificationCount = 0;
  String? colorBlindType;
  void initState() {
    super.initState();
    _loadColorBlindType();
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly':
        return const ColorFilter.mode(
          Color(0xFFFFD1DC), // Light pink to enhance red
          BlendMode.modulate,
        );
      case 'deuteranomaly':
        return const ColorFilter.mode(
          Color(0xFFDAF7A6), // Light green to enhance green
          BlendMode.modulate,
        );
      case 'tritanomaly':
        return const ColorFilter.mode(
          Color(0xFFA6E3FF), // Light cyan to enhance blue
          BlendMode.modulate,
        );
      case 'protanopia':
        return const ColorFilter.mode(
          Color(0xFFFFA07A), // Light salmon to compensate for red blindness
          BlendMode.modulate,
        );
      case 'deuteranopia':
        return const ColorFilter.mode(
          Color(0xFF98FB98), // Pale green to compensate for green blindness
          BlendMode.modulate,
        );
      case 'tritanopia':
        return const ColorFilter.mode(
          Color(0xFFADD8E6), // Light blue to compensate for blue blindness
          BlendMode.modulate,
        );
      case 'achromatopsia':
        return const ColorFilter.mode(
          Color(0xFFD3D3D3), // Light gray to provide neutral contrast
          BlendMode.modulate,
        );
      case 'achromatomaly':
        return const ColorFilter.mode(
          Color(0xFFEED5D2), // Light beige for better overall contrast
          BlendMode.modulate,
        );
      default:
        return const ColorFilter.mode(
          Colors.transparent, // No filter for 'none' or unrecognized type
          BlendMode.color,
        );
    }
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 93, 171, 164),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            _buildMenuItem(Icons.home, 'Home', context),
            SizedBox(height: 30),
            _buildMenuItem(Icons.logout, 'Log Out', context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 30),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _showNotifications(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Existing Order Notification
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.blue),
                title: const Text("New Order Received"),
                subtitle: const Text("Order #103 from Lama Ibrahim"),
              ),

              const Divider(),

              // Job Request Notification
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Job Request",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '''Username: Leen
                            Phone: 0591615357
                            Email: m.leen@gmail.com
                            CV: I'm good at ordering management
                            Store Name: Palestine Store
                            Disability: Elderly
                            Role: Store Employee''',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Remove job request notification
                                Navigator.pop(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Accept"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Remove job request notification
                                Navigator.pop(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Deny"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  setState(() {
    notificationCount = 0;
  });
}


@override
Widget build(BuildContext context) {
  final colorFilter = _getColorFilter(colorBlindType); // Ensure colorBlindType is defined

  return MaterialApp(
    home: Scaffold(
      drawer: _buildSidebar(context), // ✅ Moved to correct position
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color.fromARGB(255, 90, 193, 184)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications,
                    color: Color.fromARGB(255, 90, 193, 184)),
                onPressed: () {
                  print("🔔 Notification clicked!");
                  _showNotifications(context);
                },
                iconSize: 35,
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$notificationCount",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ColorFiltered( // ✅ Now correctly structured
        colorFilter: colorFilter,
        child: Container( // ✅ Added a child (was missing)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Store Overview",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome! 🚀 Your store is now live.",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildDashboardCard(
                  title: "Product Management",
                  icon: Icons.inventory,
                  color: Colors.blueAccent,
                  onTap: () {
                    print("Navigating to Product Management...");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductManagementPage(
                            token: widget.token),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
                _buildDashboardCard(
                  title: "Order Management",
                  icon: Icons.shopping_cart,
                  color: Colors.orangeAccent,
                  onTap: () {
                    print("Navigating to Order Management...");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderManagementPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
                _buildDashboardCard(
                  title: "Report & Analytics",
                  icon: Icons.bar_chart,
                  color: Colors.purpleAccent,
                  onTap: () {
                    print("Navigating to Reports...");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReportAnalyticsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
// ✅ تصميم البطاقات لكل قسم
  Widget _buildDashboardCard(
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
