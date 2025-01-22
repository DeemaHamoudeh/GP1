import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String productStatus = "Active";
  String? productTitle;
  String? productDescription;
  String? selectedCategory;
  String? productPrice;
  String? productStock;
  List<File> productImages = [];

  List<String> categories = [
    "Clothing",
    "Electronics",
    "Home Appliances",
    "Sports Equipment",
    "Toys & Gifts"
  ];
  int stockQuantity = 0; // Track stock count
  // 📷 Pick images
  Future<void> _pickImages() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        productImages.add(File(pickedFile.path));
      });
    }
  }

  // ✅ Save product
  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("✅ Product saved successfully!");
      print("Title: $productTitle");
      print("Description: $productDescription");
      print("Category: $selectedCategory");
      print("Price: $productPrice");
      print("Stock: $productStock");
      print("Images Count: ${productImages.length}");
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ "Back" Text Button (Left)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  //     fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ✅ "Active" Dropdown in the Center
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: productStatus,
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.white,
                items: ["Active", "Draft"].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      productStatus = newValue;
                    });
                  }
                },
              ),
            ),

            // ✅ "Save" Button (Right)
            GestureDetector(
              onTap: () {
                print("Save Product"); // Replace this with your save function
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Color(0xFF035cd3), // Shopify uses blue for actions
                  fontSize: 18,
                  //    fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 WRAP MAIN CONTENT IN A CONTAINER WITH PADDING
            Container(
              padding: EdgeInsets.all(
                  16.0), // ✅ Keeps padding for all elements EXCEPT dividers
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Media",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: productImages.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined,
                                        size: 25,
                                        color: const Color(0xFF035cd3)),
                                    SizedBox(height: 8),
                                    Text("Add images",
                                        style: TextStyle(
                                            color: const Color(0xFF035cd3),
                                            fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text("Pick a plan to add more media types",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14)),
                                  ],
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: productImages.map((image) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(image,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                            Positioned(
                                              top: 2,
                                              right: 2,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    productImages.remove(image);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(Icons.close,
                                                      color: Colors.white,
                                                      size: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Product title",
                        hintStyle:
                            TextStyle(fontSize: 24, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter product title" : null,
                      onSaved: (value) => productTitle = value,
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.add, color: Colors.grey[700]),
                      title: Text("Add description",
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600])),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey[500]),
                      onTap: () {},
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.add, color: Colors.grey[700]),
                      title: Text("Select category",
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600])),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey[500]),
                      onTap: () {},
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    SizedBox(height: 16),

                    // ✅ Price Field
                    Text(
                      "₪0.00",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ), // 🔹 END WRAPPED CONTAINER

            // ✅ FULL-WIDTH SECTION DIVIDER (Before Variants)
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.grey[200],
            ),

            // 🔹 VARIANTS SECTION

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0), // Ensures alignment with other sections
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  // ✅ Variants Title
                  Text(
                    "Variants",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(177, 0, 0, 0),
                    ),
                  ),

                  // ✅ Add Options Button (with Icon)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.add, color: Colors.grey[700]),
                    title: Text(
                      "Add options (color, size, etc.)",
                      style: TextStyle(
                          fontSize: 17,
                          //fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.grey),
                    onTap: () {
                      print("Navigate to Variants Page");
                    },
                  ),
                ],
              ),
            ),

            // ✅ FULL-WIDTH SECTION DIVIDER (After Variants)
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.grey[200],
            ),
            SizedBox(height: 8),
// 🔹 INVENTORY SECTION
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0), // Ensures alignment
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Inventory Title with Edit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Inventory",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(177, 0, 0, 0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Navigate to Edit Inventory");
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF035cd3),
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // ✅ Stock Management Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),

                      // 🔹 Counter for Stock ( - 0 + )
                      Row(
                        children: [
                          // Decrease Button (-)
                          GestureDetector(
                            onTap: () {
                              if (stockQuantity > 0) {
                                setState(() {
                                  stockQuantity--;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  //       border: Border.all(color: Colors.grey),
                                  //  borderRadius: BorderRadius.circular(4),
                                  ),
                              child: Icon(Icons.remove,
                                  size: 18, color: Colors.grey[700]),
                            ),
                          ),
                          SizedBox(width: 12),

                          // 🔹 Stock Quantity with Grey Background
                          Container(
                            width: 100,
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200], // ✅ Grey background
                              borderRadius: BorderRadius.circular(
                                  17), // ✅ Rounded corners
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$stockQuantity", // ✅ Dynamic stock count
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          SizedBox(width: 12),

                          // Increase Button (+)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                stockQuantity++;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                //   color: Colors.grey[200], // ✅ Grey background
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(Icons.add,
                                  size: 18, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),

// ✅ FULL-WIDTH SECTION DIVIDER (After Inventory)
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
