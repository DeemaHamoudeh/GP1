import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'PageViewScreen_page.dart';

class StorePreviewPage extends StatefulWidget {
  final String theme;
  final String storeName;

  StorePreviewPage({Key? key, required this.theme, required this.storeName})
      : super(key: key);

  @override
  _StorePreviewPageState createState() => _StorePreviewPageState();
}

class _StorePreviewPageState extends State<StorePreviewPage> {
  String? storeTitle;
  String heroText = "Discover the best products for you!";
  String footerText = "© 2025 All rights reserved";
  bool isEditingHeader = false;
  bool isEditingHero = false;
  bool isEditingFooter = false;
  File? heroImageFile;
  String? heroImagePath;
  List<String> menuItems = []; // 🆕 قائمة العناصر المخزنة في Main Menu
  final List<Map<String, String>> products = [
    {
      "name": "Elegant Chair",
      "price": "\$49.99",
      "image": "assets/images/welcomingPages/delievery.png",
    },
    {
      "name": "Modern Lamp",
      "price": "\$29.99",
      "image": "assets/images/welcomingPages/delievery.png",
    },
    {
      "name": "Minimal Table",
      "price": "\$79.99",
      "image": "assets/images/welcomingPages/delievery.png",
    },
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    storeTitle = widget.storeName;
    _loadSavedData();
  }

  // ✅ تحميل البيانات المخزنة
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      storeTitle = prefs.getString("storeTitle") ?? widget.storeName;
      heroText = prefs.getString("heroText") ?? heroText;
      heroImagePath = prefs.getString("heroImagePath");
      footerText = prefs.getString("footerText") ?? footerText;
    });

    // ✅ Load Pages from SharedPreferences and Convert JSON to List
    final String? storedPages = prefs.getString("pages");
    if (storedPages != null) {
      try {
        List<dynamic> decodedPages = json.decode(storedPages);
        setState(() {
          menuItems = decodedPages
              .map((item) => item["title"] as String)
              .toList(); // Extracting only the titles
        });

        print("📌 Loaded pages in menu: $menuItems");
      } catch (e) {
        print("❌ Error loading pages: $e");
      }
    }
  }

  // ✅ حفظ البيانات
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("storeTitle", storeTitle!);
    prefs.setString("heroText", heroText);
    prefs.setString("footerText", footerText);
    if (heroImagePath != null) {
      prefs.setString("heroImagePath", heroImagePath!);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Changes saved successfully!")),
    );
  }

  // ✅ التقاط صورة للـ Hero Section
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        heroImageFile = File(pickedFile.path);
        heroImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Customize Store"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: menuItems
                .isNotEmpty // 🆕 إضافة زر القائمة الجانبية إذا كان هناك عناصر
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.teal),
            onPressed: _saveData,
          ),
        ],
      ),

      // 🆕 إضافة Drawer للقائمة الجانبية
      drawer: menuItems.isNotEmpty
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.black),
                    child: Text(
                      "Main Menu",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                  for (String item in menuItems)
                    ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context); // Close drawer
                        _navigateToPage(item); // Open respective page
                      },
                    ),
                ],
              ),
            )
          : null,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header Section
            // ✅ Header Section (Now contains the menu icon)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Colors.black,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align elements
                children: [
                  // 📌 Menu Icon (ONLY appears if menuItems exist)
                  if (menuItems.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        _scaffoldKey.currentState
                            ?.openDrawer(); // ✅ Now it works correctly
                      },
                    ),

                  // 📌 Store Title
                  Expanded(
                    child: isEditingHeader
                        ? TextField(
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                            autofocus: true,
                            onSubmitted: (value) {
                              setState(() {
                                storeTitle =
                                    value.isNotEmpty ? value : storeTitle;
                                isEditingHeader = false;
                              });
                            },
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          )
                        : Center(
                            child: Text(
                              storeTitle!,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                  ),

                  // 📌 Edit Icon
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        isEditingHeader = true;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // ✅ Hero Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: heroImagePath != null
                      ? DecorationImage(
                          image: FileImage(File(heroImagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Center(
                  child: isEditingHero
                      ? TextField(
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                          autofocus: true,
                          onSubmitted: (value) {
                            setState(() {
                              heroText = value.isNotEmpty ? value : heroText;
                              isEditingHero = false;
                            });
                          },
                          decoration: InputDecoration(border: InputBorder.none),
                        )
                      : Text(
                          heroText,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // ✅ Featured Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Featured Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length, // ✅ Use the correct list length
              itemBuilder: (context, index) {
                return _buildProductCard(
                    products[index]); // ✅ Pass the product data here
              },
            ),

            SizedBox(height: 40),

            // ✅ Footer Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Colors.black,
              child: Text(
                footerText,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(String pageName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedPages = prefs.getString("pages");

    if (storedPages != null) {
      try {
        List<dynamic> decodedPages = json.decode(storedPages);
        Map<String, dynamic>? selectedPage = decodedPages.firstWhere(
          (page) => page["title"] == pageName,
          orElse: () => null, // If no match, return null
        );

        if (selectedPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageViewScreen(
                title: selectedPage["title"],
                content: selectedPage["content"],
              ),
            ),
          );
        } else {
          print("❌ Page not found: $pageName");
        }
      } catch (e) {
        print("❌ Error loading page content: $e");
      }
    }
  }

  Widget _buildProductCard(Map<String, String> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(product["image"]!,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(product["name"]!, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

  // ✅ الانتقال إلى صفحة جديدة عند النقر على عنصر في القائمة
 