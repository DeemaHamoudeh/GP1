import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'addNewPage_page.dart';
import '../../../../controllers/userController.dart';

class PagesListPage extends StatefulWidget {
  final String? token;
  const PagesListPage({Key? key, required this.token}) : super(key: key);
  @override
  _PagesListPageState createState() => _PagesListPageState();
}

class _PagesListPageState extends State<PagesListPage> {
  List<Map<String, String>> pages = [];
  String? token;
  @override
  void initState() {
    super.initState();
    token = widget.token; // ✅ Store the token for API use if needed
    print("Token received: $token");
    _loadPages(); // Load saved pages when opening the page
  }

  Future<void> _loadPages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedPages = prefs.getString('pages');

    if (storedPages != null) {
      try {
        List<dynamic> decodedList = json.decode(storedPages);
        setState(() {
          pages = decodedList
              .map((item) => Map<String, String>.from(item as Map))
              .toList();
        });
      } catch (e) {
        print(" Error loading pages: $e");
      }
    } else {
      print(" No saved pages found.");
    }
  }

  //  Save pages to SharedPreferences after adding/editing/deleting
  Future<void> _savePages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pages', json.encode(pages));
    print("Pages saved successfully: $pages");
    final userController = UserController();

    //  Mark Step 2 (Add Product) as completed
    print(" Marking Step 3 as completed...");
    await userController.updateSetupGuide(widget.token ?? "", 3, true);
    print(" Step 3 marked as completed.");

    //  Reload setup guide to reflect changes in dashboard
    await userController.fetchSetupGuide(widget.token ?? "");
    if (mounted) {
      print("mouted");
      //  Navigator.pop(context, true); //  Go back after saving
    }
  }

  void _navigateToAddPage(
      {Map<String, String>? existingPage, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewPage(
          existingPage: existingPage,
        ),
      ),
    );

    if (result == "delete" && index != null) {
      //  Delete the page safely
      setState(() {
        pages.removeAt(index!); // Use "!" to ensure it's non-null
      });

      print("✅ Page deleted successfully.");

      await _savePages(); //  Save updated list after deletion
    } else if (result != null) {
      //  Save or update the page
      setState(() {
        if (index != null) {
          pages[index] = Map<String, String>.from(result);
        } else {
          pages.add(Map<String, String>.from(result));
        }
      });

      await _savePages(); // Save updated list after adding/editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pages"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () => _navigateToAddPage(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadPages(), //  Ensuring pages are loaded correctly
        builder: (context, snapshot) {
          return pages.isEmpty
              ? Center(
                  child: Text(
                    "No pages added yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  itemCount: pages.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(pages[index]['title']!),
                      subtitle: Text("Last updated: Today"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      onTap: () => _navigateToAddPage(
                          existingPage: pages[index], index: index),
                    );
                  },
                );
        },
      ),
    );
  }
}
