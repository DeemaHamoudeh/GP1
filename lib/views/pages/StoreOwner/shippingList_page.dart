import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'addShipping_page.dart';
import 'shippingOptions_page.dart';
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
  String selectedDeliveryMethod = "External"; // "Warehouse" أو "External"

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

  void _navigateToShippingOptions() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingOptionsPage(),
      ),
    );

    if (result != null) {
      if (result == "add_new") {
        _navigateToAddShipping(); // ✅ إذا اختار "إضافة شركة جديدة"، ينتقل إلى صفحة الإدخال
      } else {
        setState(() {
          shippingCompanies
              .add(result); // ✅ إضافة الشركة المختارة مباشرةً إلى القائمة
        });
        await _saveShippingCompanies(); // ✅ حفظ الشركة الجديدة
      }
    }
  }

  Widget _buildDeliveryOption(String title, String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDeliveryMethod = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedDeliveryMethod == value
                ? Colors.teal
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selectedDeliveryMethod == value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveWarehouseSelection() async {
    if (selectedWarehouse != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedWarehouse', selectedWarehouse!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Warehouse '$selectedWarehouse' selected!")),
      );

      print("✅ Warehouse selected: $selectedWarehouse");
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
  }

  List<String> warehouses = [
    "Nablus-Rafedia St Warehouse",
    "Nablus-Najah St Warehouse",
    "Ramallah-Alarsal St Warehouse"
  ];

  String? selectedWarehouse; // 🔹 متغير لتخزين المستودع المختار

  Widget _buildWarehouseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select a Warehouse:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // 🔹 قائمة اختيار المستودعات
        DropdownButtonFormField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          items: warehouses.map((wh) {
            return DropdownMenuItem(value: wh, child: Text(wh));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedWarehouse = value as String?;
            });
          },
        ),

        SizedBox(height: 20),

        // 🔹 زر الحفظ يظهر فقط إذا تم اختيار مستودع
        if (selectedWarehouse != null)
          ElevatedButton(
            onPressed: () {
              _saveWarehouseSelection();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Center(
              child: Text("Save Warehouse Selection",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
      ],
    );
  }

  Widget _buildShippingCompaniesList() {
    return shippingCompanies.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No shipping companies added yet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                // onPressed: () => _navigateToAddShipping(),
                onPressed: () => _navigateToShippingOptions(),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add Shipping Company",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          )
        : Expanded(
            child: ListView.separated(
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
            onPressed: () => _navigateToShippingOptions(),
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       title: Text("Shipping & Delivery"),
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back, color: Colors.black),
  //         onPressed: () => Navigator.pop(context, true),
  //       ),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Choose Delivery Method:",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

  //           SizedBox(height: 10),

  //           // 🔹 اختيار طريقة التوصيل
  //           Row(
  //             children: [
  //               _buildDeliveryOption("Warehouse & Staff", "Warehouse"),
  //               SizedBox(width: 10),
  //               _buildDeliveryOption("External Delivery", "External"),
  //             ],
  //           ),

  //           SizedBox(height: 20),

  //           // 🔹 عرض القسم المناسب بناءً على الاختيار
  //           selectedDeliveryMethod == "Warehouse"
  //               ? _buildWarehouseSelection()
  //               : _buildShippingCompaniesList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
