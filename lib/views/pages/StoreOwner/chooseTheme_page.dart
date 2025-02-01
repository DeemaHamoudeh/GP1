import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tryMinimal_page.dart';
import 'storePrevie_page.dart';

class ChooseThemePage extends StatefulWidget {
  final String? token;

  const ChooseThemePage({Key? key, required this.token}) : super(key: key);

  @override
  State<ChooseThemePage> createState() => _ChooseThemePageState();
}

class _ChooseThemePageState extends State<ChooseThemePage> {
  List<Map<String, String>> themes = [
    {
      "name": "Modern Minimalist",
      "version": "15.2.0",
      "image": "assets/images/themePages/ModernMinimalist8.jpg",
    },
    {
      "name": "Dark Mode",
      "version": "15.2.0",
      "image": "assets/images/themePages/dark.jpg",
    },
    {
      "name": "Elegant Boutique",
      "version": "15.2.0",
      "image": "assets/images/themePages/elegant.jpg",
    }
  ];

  String? selectedTheme;

  @override
  void initState() {
    super.initState();
    _loadSelectedTheme(); // ✅ Load selected theme when page opens
  }

  // ✅ Load Selected Theme from SharedPreferences
  Future<void> _loadSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = prefs.getString("selectedTheme");
    });
  }

  // ✅ Save Selected Theme
  Future<void> _saveSelectedTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedTheme", themeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Themes"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedTheme != null) _buildSelectedThemeSection(),
                  SizedBox(height: 8),
                  Text(
                    "Theme Library",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Choose a theme for your store. You can customize it later.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: themes.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 25,
              ),
              itemBuilder: (context, index) {
                return _buildThemeBlock(themes[index]);
              },
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Selected Theme Section
  Widget _buildSelectedThemeSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StorePreviewPage(theme: selectedTheme!, storeName: "Body Shop"),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Selected Theme: $selectedTheme",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }

  // ✅ Theme List
  Widget _buildThemeBlock(Map<String, String> theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              theme["image"]!,
              height: 140,
              width: 130,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  theme["name"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Version ${theme["version"]}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (theme["name"] == "Modern Minimalist") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TryMinimalPage()),
                          );
                        }
                      },
                      child: Text("Try"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[200],
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTheme = theme["name"];
                        });
                        _saveSelectedTheme(theme["name"]!); // ✅ Save it
                      },
                      child: Text("Choose"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
