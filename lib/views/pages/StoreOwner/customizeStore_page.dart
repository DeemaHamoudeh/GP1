import 'package:flutter/material.dart';
import 'chooseTheme_page.dart';
import 'pagesList_page.dart';
import 'organizeNavigation_page.dart';

class CustomizeStorePage extends StatefulWidget {
  final String? token;

  const CustomizeStorePage({Key? key, required this.token}) : super(key: key);

  @override
  State<CustomizeStorePage> createState() => _CustomizeStorePageState();
}

class _CustomizeStorePageState extends State<CustomizeStorePage> {
  String? token;

  @override
  void initState() {
    super.initState();
    token = widget.token; // ✅ Store the token for API use if needed
    print("Token received: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Soft background color
      appBar: AppBar(
        title: Text("Online store"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildOptionCard(
              context,
              icon: Icons.palette,
              title: "Manage Themes",
              description: "Choose and customize your store theme.",
              color: Colors.blueAccent, // ✅ More engaging colors
              onTap: () {
                print("Manage Themes Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseThemePage(
                        token: token), // ✅ Navigate to ChooseThemePage
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            _buildOptionCard(
              context,
              icon: Icons.insert_drive_file,
              title: "Add a Page to Store",
              description: "Create new pages like About Us and Contact.",
              color: Colors.green, // ✅ Different color for distinction
              onTap: () {
                print("Add a Page Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PagesListPage(
                        token: widget.token), // ✅ Navigate to ChooseThemePage
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            _buildOptionCard(
              context,
              icon: Icons.menu,
              title: "Organize Navigation",
              description: "Manage menu and link pages.",
              color: Colors.teal, // ✅ Third unique color
              onTap: () {
                print("Organize Navigation Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrganizeNavigationPage(), // ✅ Navigate to ChooseThemePage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[120],
        elevation: 4, //  Slight elevation
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              //  Colored Circular Icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
