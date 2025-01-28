import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'addShipping_page.dart';
import '../../../../controllers/userController.dart';

class ShippingListPage extends StatefulWidget {
  final String? token;

  const ShippingListPage({Key? key, required this.token}) : super(key: key);
  @override
  _ShippingListPageState createState() => _ShippingListPageState();
}

class _ShippingListPageState extends State<ShippingListPage> {
  List<Map<String, dynamic>> shippingCompanies = [];
  String? token;
  @override
  void initState() {
    super.initState();
    token = widget.token; // ✅ Store the token for API use if needed
    print("Token received: $token");
    _loadShippingCompanies();
  }

  // ✅ تحميل البيانات المحفوظة
  Future<void> _loadShippingCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedCompanies = prefs.getString('shippingCompanies');

    if (storedCompanies != null) {
      setState(() {
        shippingCompanies = List<Map<String, dynamic>>.from(
          json.decode(storedCompanies),
        );
      });
    }
  }

  // ✅ حفظ الشركات بعد الإضافة أو التعديل
  Future<void> _saveShippingCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shippingCompanies', json.encode(shippingCompanies));

    final userController = UserController();

    //  Mark Step 2 (Add Product) as completed
    print(" Marking Step 4 as completed...");
    await userController.updateSetupGuide(widget.token ?? "", 4, true);
    print(" Step 4 marked as completed.");

    //  Reload setup guide to reflect changes in dashboard
    await userController.fetchSetupGuide(widget.token ?? "");
    if (mounted) {
      print("mouted");
      //  Navigator.pop(context, true); //  Go back after saving
    }
  }

  // ✅ الانتقال إلى صفحة الإضافة أو التعديل
  void _navigateToAddShipping(
      {Map<String, dynamic>? existingCompany, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShippingPage(existingCompany: existingCompany),
      ),
    );

    if (result == "delete" && index != null) {
      // ✅ حذف الشركة من القائمة
      setState(() {
        shippingCompanies.removeAt(index);
      });

      print("✅ Shipping company deleted successfully.");

      await _saveShippingCompanies(); // ✅ حفظ البيانات بعد الحذف
    } else if (result != null) {
      // ✅ تعديل أو إضافة شركة
      setState(() {
        if (index != null) {
          shippingCompanies[index] = result; // تعديل شركة موجودة
        } else {
          shippingCompanies.add(result); // إضافة شركة جديدة
        }
      });

      await _saveShippingCompanies(); // ✅ حفظ البيانات بعد الإضافة أو التعديل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shipping & Delivery"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () => _navigateToAddShipping(),
          ),
        ],
      ),
      body: shippingCompanies.isEmpty
          ? Center(
              child: Text(
                "No shipping companies added yet.\nTap + to add a new one.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              itemCount: shippingCompanies.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(shippingCompanies[index]['name']),
                  subtitle: Text(
                      "⏳ ${shippingCompanies[index]['duration']} days  |  💰 ${shippingCompanies[index]['cost']}"),
                  trailing: Icon(Icons.edit, color: Colors.grey),
                  onTap: () => _navigateToAddShipping(
                      existingCompany: shippingCompanies[index], index: index),
                );
              },
            ),
    );
  }
}
