import 'package:flutter/material.dart';
import 'mainMenu_page.dart';

class OrganizeNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menus"),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildInfoBanner(), // ✅ Info banner at the top
          _buildMenuItem(
            context,
            title: "Main menu",
            subtitle: "About us, Contact",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainMenuPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            title: "Footer menu",
            subtitle: "",
            onTap: () {}, // No action (static for now)
          ),
          _buildMenuItem(
            context,
            title: "Customer account main menu",
            subtitle: "",
            onTap: () {}, // No action (static for now)
          ),
        ],
      ),
    );
  }

  // 🔹 Info banner at the top
  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      color: Colors.blue.shade50,
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Navigation is now Menus under Content\nManage menus for your online store and customer accounts",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Icon(Icons.close, color: Colors.grey),
        ],
      ),
    );
  }

  // 🔹 Menu item widget
  Widget _buildMenuItem(BuildContext context,
      {required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}

// ✅ Dummy Page for Editing Main Menu
class EditMainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(child: Text("Edit Main Menu Page")),
    );
  }
}
