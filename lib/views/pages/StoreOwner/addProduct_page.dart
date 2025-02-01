import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/productController.dart';
import '../../../../controllers/userController.dart';

class AddProductPage extends StatefulWidget {
  final String? token;

  const AddProductPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  String productStatus = "Active";
  String productTitle = "";
  String productDescription = "";
  String? selectedCategory;
  String productPrice = "";
  String productStock = "";
  List<File> productImages = [];

  List<String> categories = [
    "Clothing & Fashion",
    "Electronics & Gadgets",
    "Home & Living",
    "Sports & Outdoors",
    "Toys & Games",
    "Health",
    "Skin Care",
    "Hair Care",
    "Automotive & Accessories",
    "Books & Stationery",
    "Food & Beverages",
    "Handmade & Crafts",
    "Pet Supplies",
  ];
  int stockQuantity = 0; // Track stock count
  List<Map<String, dynamic>> variants = [];
  List<Map<String, dynamic>> productVariants = [];

//  //  Save product
//   void _saveProduct() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       print(" Product saved successfully!");
//       print("Title: $productTitle");
//       print("Description: $productDescription");
//       print("Category: $selectedCategory");
//       print("Price: $productPrice");
//       print("Stock: $productStock");
//       print("Images Count: ${productImages.length}");
//       Navigator.pop(context); // Go back after saving
//     }
//   }
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return; //  Stop if the form is not valid
    }

    _formKey.currentState!.save();

    //  Convert local file paths to strings
    List<String> imagePaths = productImages.map((image) {
      return image.path; // Use file paths (Handle base64 if necessary)
    }).toList();

    Map<String, dynamic> productData = {
      "title": productTitle,
      "description": productDescription,
      "category": selectedCategory,
      "price": double.tryParse(productPrice) ?? 0,
      "images": imagePaths, //  Ensure images are just file paths
      "status": productStatus,
      "variants": variants,
    };

    print("🛠️ Final Product Data: $productData"); // Debugging

    var response = await ProductController.addProduct(
      token: widget.token ?? "", //  Ensure token is not null
      productData: productData,
    );

    if (response["success"]) {
      print("✅ Product added successfully!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product added successfully!")),
      );

      final userController = UserController();

      //  Mark Step 2 (Add Product) as completed
      print(" Marking Step 2 as completed...");
      await userController.updateSetupGuide(widget.token ?? "", 2, true);
      print(" Step 2 marked as completed.");

      //  Reload setup guide to reflect changes in dashboard
      await userController.fetchSetupGuide(widget.token ?? "");
      print(" Setup guide reloaded.");

      //  Ensure navigation happens AFTER updates
      if (mounted) {
        print("Navigating back to Dashboard...");
        Navigator.pop(context, true); //  Go back after saving
      }
    } else {
      print(" Failed to add product: ${response["message"]}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${response["message"]}")),
      );
    }
  }

  // 📷 Pick images
  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        productImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _generateVariants() {
    if (variants.isEmpty) {
      setState(() {
        productVariants
            .clear(); // Ensure the list is cleared if no variants exist
      });
      return;
    }

    List<List<String>> optionValues =
        variants.map((option) => List<String>.from(option['values'])).toList();

    List<List<String>> combinations = _generateCombinations(optionValues);

    setState(() {
      productVariants = combinations.map((combination) {
        return {
          "name": combination.join(" / "),
          "image": null,
          "stock": 0,
        };
      }).toList();
    });

    print("Generated Variants: $productVariants"); // Debugging
  }

  void _showInventoryEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 500,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              Icon(Icons.close, size: 24, color: Colors.black),
                        ),
                        Text(
                          "Shop location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 24), // Placeholder for spacing
                      ],
                    ),
                    SizedBox(height: 16),

                    // ✅ Search Bar
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // ✅ Inventory List
                    Expanded(
                      child: ListView.builder(
                        itemCount: productVariants.length,
                        itemBuilder: (context, index) {
                          final variant = productVariants[index];

                          return Column(
                            children: [
                              ListTile(
                                leading: variant["image"] != null
                                    ? Image.file(
                                        File(variant["image"]),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image, color: Colors.grey),
                                title: Text(variant["name"]),
                                subtitle: Text("${variant["stock"]} available"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (variant["stock"] > 0) {
                                          setState(() {
                                            variant["stock"]--;
                                          });
                                        }
                                      },
                                      child: Icon(Icons.remove_circle,
                                          color: Colors.grey, size: 24),
                                    ),
                                    SizedBox(width: 12),
                                    Text("${variant["stock"]}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          variant["stock"]++;
                                        });
                                      },
                                      child: Icon(Icons.add_circle,
                                          color: Colors.blue, size: 24),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey[300]),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<List<String>> _generateCombinations(List<List<String>> lists) {
    if (lists.isEmpty) return [[]];
    List<List<String>> result = [[]];

    for (List<String> list in lists) {
      List<List<String>> temp = [];
      for (List<String> res in result) {
        for (String item in list) {
          temp.add([...res, item]);
        }
      }
      result = temp;
    }
    return result;
  }

  int _calculateTotalStock() {
    return productVariants.fold(
        0, (total, variant) => total + (variant["stock"] as int? ?? 0));
  }

  void _showInventoryManagement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: 24, color: Colors.black),
                      ),
                      Text(
                        "Shop location",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 24), // مكان فارغ لموازنة العناصر
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productVariants.length,
                      itemBuilder: (context, index) {
                        final variant = productVariants[index];

                        return Column(
                          children: [
                            ListTile(
                              leading: variant["image"] != null
                                  ? Image.file(File(variant["image"]),
                                      width: 40, height: 40, fit: BoxFit.cover)
                                  : Icon(Icons.image_outlined,
                                      size: 40, color: Colors.grey),
                              title: Text(variant["name"],
                                  style: TextStyle(fontSize: 16)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (variant["stock"] > 0)
                                          variant["stock"]--;
                                      });
                                    },
                                    child: Icon(Icons.remove_circle,
                                        color: Colors.grey, size: 24),
                                  ),
                                  SizedBox(width: 12),
                                  Text("${variant["stock"]}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        variant["stock"]++;
                                      });
                                    },
                                    child: Icon(Icons.add_circle,
                                        color: Colors.blue, size: 24),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey[300]),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showVariantDetailPage(Map<String, dynamic> variant, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header: Close Button and Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              Icon(Icons.close, size: 24, color: Colors.black),
                        ),
                        Expanded(
                          child: Text(
                            variant["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.more_vert, color: Colors.black),
                      ],
                    ),

                    SizedBox(height: 16),

                    // ✅ Product Image (Add/Edit Option)
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            variant["image"] = pickedFile.path;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: variant["image"] == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        size: 30, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text("Add image",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16)),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(variant["image"]),
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Builder(builder: (context) {
                      List<String> nameParts = variant["name"].split(" / ");
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOptionRow("Color", nameParts[0]),
                          if (nameParts.length > 1)
                            _buildOptionRow("Size", nameParts[1]),
                        ],
                      );
                    }),

                    Divider(
                        height: 20, thickness: 1, color: Colors.grey.shade300),

                    // Price Field
                    _buildEditableRow(
                      title: "₪ Price",
                      value: variant["price"] ?? "₪0.00",
                      onTap: () {
                        _showEditDialog(
                          title: "Price",
                          initialValue: variant["price"] ?? "0.00",
                          isNumeric: true,
                          onSave: (value) {
                            setState(() {
                              variant["price"] = value;
                            });
                          },
                        );
                      },
                    ),

                    Divider(
                        height: 20, thickness: 1, color: Colors.grey.shade300),

                    //  Inventory Section
                    _buildInventorySection(variant, setState),

                    Divider(
                        height: 20, thickness: 1, color: Colors.grey.shade300),

                    //  Shipping Section
                    ListTile(
                      leading: Icon(Icons.local_shipping, color: Colors.black),
                      title: Text("Shipping"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      onTap: () {},
                    ),

                    Spacer(),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          productVariants[index] = Map.from(variant);
                        });

                        // Notify parent widget (AddProductPage) about the update
                        if (mounted) {
                          setState(() {});
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF035cd3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text("Save",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      //  Ensure state is updated when the modal is closed
      if (mounted) {
        setState(() {});
      }
    });
  }

// function to Build a Single Row for Options (Color, Size)
  Widget _buildOptionRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

// Function to Build an Editable Row (Price)
  Widget _buildEditableRow(
      {required String title,
      required String value,
      required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

//  Function to Build Inventory Section
  Widget _buildInventorySection(
      Map<String, dynamic> variant, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Inventory",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                _showEditDialog(
                  title: "Stock",
                  initialValue: variant["stock"].toString(),
                  isNumeric: true,
                  onSave: (value) {
                    setState(() {
                      variant["stock"] = int.tryParse(value) ?? 0;
                    });
                  },
                );
              },
              child: Text("Edit",
                  style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Available",
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (variant["stock"] > 0) variant["stock"]--;
                    });
                  },
                  child:
                      Icon(Icons.remove_circle, color: Colors.grey, size: 24),
                ),
                SizedBox(width: 12),
                Text("${variant["stock"]}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      variant["stock"]++;
                    });
                  },
                  child: Icon(Icons.add_circle, color: Colors.blue, size: 24),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showVariantDetailsBottomSheet(Map<String, dynamic> variant, int index) {
    if (!mounted) return; //  Prevent crashes due to unmounted state

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  height: 500,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(Icons.close,
                                size: 24, color: Colors.black),
                          ),
                          Text(
                            variant['name'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  variants[index]['values'] = variant['values']
                                      .where((v) => v.trim().isNotEmpty)
                                      .toList();
                                });

                                _generateVariants(); // Ensures variants are updated properly

                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }

                                Future.delayed(Duration(milliseconds: 200), () {
                                  if (mounted && context.mounted) {
                                    _showVariantsBottomSheet();
                                  }
                                });
                              }
                            },
                            child: Text("Save",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Editable List of Variant Values
                      Expanded(
                        child: ListView.builder(
                          itemCount: variant['values'].length,
                          itemBuilder: (context, valueIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Enter value",
                                      ),
                                      onChanged: (text) {
                                        if (mounted) {
                                          setState(() {
                                            variant['values'][valueIndex] =
                                                text;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      // Delete Option Button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                variants.removeAt(index);
                              });
                            }
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Delete Option",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showVariantsBottomSheet() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context); //  Only closes if needed
                          }
                        },
                        child: Icon(Icons.close, size: 24, color: Colors.black),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Options",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${variants.length} variants",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Add Option Button
                  ListTile(
                    leading: Icon(Icons.add, color: Colors.blue, size: 24),
                    title: Text(
                      "Add option",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    onTap: () {
                      print("in _showVariantsBottomSheet : ");
                      print(
                          "Widget mounted: $mounted, Context mounted: ${context.mounted}");

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && context.mounted) {
                          _showAddVariantBottomSheet();
                        }
                      });
                    },
                  ),

                  // Variants List
                  Expanded(
                    child: variants.isEmpty
                        ? Center(child: Text("No options added yet"))
                        : ListView.builder(
                            itemCount: variants.length,
                            itemBuilder: (context, index) {
                              final variant = variants[index];
                              return ListTile(
                                title: Text(variant['name']),
                                subtitle:
                                    Text("${variant['values'].length} values"),
                                onTap: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }

                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    if (mounted && context.mounted) {
                                      _showVariantDetailsBottomSheet(
                                          variant, index);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // **Show Add Variant Bottom Sheet**
  void _showAddVariantBottomSheet() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddVariantBottomSheet(onSave: (variant) {
          if (!mounted) return;

          setState(() {
            variants.add(variant);
            _generateVariants();
          });

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              _showVariantsBottomSheet();
            }
          });
        });
      },
    );
  }

  void _showEditDialog({
    required String title,
    required String initialValue,
    required Function(String) onSave,
    bool isNumeric = false,
  }) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showCategorySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 650,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select a Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(categories[index]),
                      trailing: selectedCategory == categories[index]
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; //  Ensures widget isn't disposed

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("widget.token:");
    print(widget.token);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Back" Text Button (Left)
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

            // "Active" Dropdown in the Center
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

            // "Save" Button (Right)
            GestureDetector(
              onTap: () {
                print("Save Product");
                _saveProduct();
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Color(0xFF035cd3),
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
            Container(
              padding: EdgeInsets.all(
                  16.0), // Keeps padding for all elements EXCEPT dividers
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
                    SizedBox(height: 29),
                    GestureDetector(
                      onTap: () {
                        _showEditDialog(
                          title: "Product Title",
                          initialValue: productTitle,
                          onSave: (value) {
                            setState(() {
                              productTitle = value;
                            });
                          },
                        );
                      },
                      child: Text(
                        productTitle.isEmpty ? "Product title" : productTitle,
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                      ),
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
                      onTap: () {
                        _showEditDialog(
                          title: "Description",
                          initialValue: productDescription,
                          onSave: (value) {
                            setState(() {
                              productDescription = value;
                            });
                          },
                        );
                      },
                    ),

                    Divider(color: Colors.grey.shade300, thickness: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.add, color: Colors.grey[700]),
                      title: Text(
                        selectedCategory ?? "Select category",
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedCategory == null
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey[500]),
                      onTap: () {
                        _showCategorySelection();
                      },
                    ),

                    Divider(color: Colors.grey.shade300, thickness: 1),
                    SizedBox(height: 16),

                    // Price Field

                    GestureDetector(
                      onTap: () {
                        _showEditDialog(
                          title: "Price",
                          initialValue: productPrice,
                          isNumeric: true, // Restrict input to numbers
                          onSave: (value) {
                            setState(() {
                              productPrice = value.isNotEmpty
                                  ? value
                                  : "0.00"; // Default value if empty
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          productPrice.isEmpty
                              ? "₪0.00"
                              : "₪$productPrice", //  Display price or placeholder
                          style: TextStyle(
                            fontSize: 20,
                            color: productPrice.isEmpty
                                ? Colors.grey[600]
                                : Colors.black, //  Light gray if empty
                            //   fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
// Divider(color: Colors.grey.shade300, thickness: 1),

                    SizedBox(height: 5),
                  ],
                ),
              ),
            ), // 🔹 END WRAPPED CONTAINER

            // FULL-WIDTH SECTION DIVIDER (Before Variants)
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.grey[200],
            ),

            if (variants.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Options",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(177, 0, 0, 0),
                          ),
                        ),
                        SizedBox(width: 250),
                        TextButton(
                          onPressed: _showVariantsBottomSheet,
                          child: Text("Edit",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF035cd3),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Ensure left alignment
                      children: variants.map((variant) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ عنوان الخيار مع عدد القيم الخاصة به
                              Text(
                                "${variant['name']} (${variant['values'].length})",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 6),

                              Container(
                                width: double
                                    .infinity, // Force full width for alignment
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      variant['values'].map<Widget>((value) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(value,
                                          style: TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 10,
                color: Colors.grey[200],
              ),
            ],

            // VARIANTS SECTION

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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

                  //  If No Options Exist -> Show "Add Options" Button
                  if (productVariants.isEmpty)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.add, color: Colors.grey[700]),
                      title: Text(
                        "Add options (color, size, etc.)",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.grey),
                      onTap: _showVariantsBottomSheet,
                    ),

                  // If Options Exist -> Show Generated Variants (Groups)
                  if (productVariants.isNotEmpty)
                    if (productVariants.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true, // Prevents infinite height issues
                        physics:
                            NeverScrollableScrollPhysics(), // Disables inner scrolling
                        itemCount: productVariants.length,
                        itemBuilder: (context, index) {
                          final variant = productVariants[
                              index]; // Get the variant with index

                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  variant["name"], // Example: "Red / L"
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text("${variant["stock"]} available"),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => _showVariantDetailPage(
                                    variant, index), //  Fixed
                              ),
                              Divider(height: 1, color: Colors.grey[300]),
                            ],
                          );
                        },
                      ),
                ],
              ),
            ),

            // FULL-WIDTH SECTION DIVIDER (After Variants)
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
                  // Inventory Title
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
                      if (productVariants
                          .isEmpty) // 🔹 لا نعرض زر "Edit" إذا كان هناك خيارات
                        GestureDetector(
                          onTap: () {
                            _showInventoryEditDialog();
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF035cd3)),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),

                  if (productVariants.isEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Available",
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),

                        // Counter for Stock ( - 0 + )
                        Row(
                          children: [
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
                                child: Icon(Icons.remove,
                                    size: 18, color: Colors.grey[700]),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              width: 100,
                              height: 40,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(17),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "$stockQuantity",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  stockQuantity++;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.add,
                                    size: 18, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  if (productVariants.isNotEmpty)
                    ListTile(
                      title: Text("Available",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                      subtitle: Text("${_calculateTotalStock()} available",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      onTap: _showInventoryManagement,
                    ),
                ],
              ),
            ),

            SizedBox(height: 14),

//  FULL-WIDTH SECTION DIVIDER (After Inventory)
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

class AddVariantBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  AddVariantBottomSheet({required this.onSave});

  @override
  _AddVariantBottomSheetState createState() => _AddVariantBottomSheetState();
}

class _AddVariantBottomSheetState extends State<AddVariantBottomSheet> {
  String? selectedOption;
  String customOptionName = ""; // لحفظ اسم الخيار المخصص
  List<String> variantOptions = [
    "Color",
    "Size",
    "Material",
    "Style",
    "Custom" // ✅ إضافة خيار "مخصص"
  ];
  List<String> values = [""]; // تبدأ بقيمة واحدة

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ **Top Bar (Close, Title, Save Button)**
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Option",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: (selectedOption != null &&
                            values.any((v) => v.trim().isNotEmpty))
                        ? () {
                            widget.onSave({
                              "name": selectedOption == "Custom"
                                  ? customOptionName
                                  : selectedOption, // ✅ حفظ الاسم المخصص إذا كان `Custom`
                              "values": values
                                  .where((v) => v.trim().isNotEmpty)
                                  .toList(),
                            });
                          }
                        : null,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: (selectedOption != null &&
                                values.any((v) => v.trim().isNotEmpty))
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // *Dropdown to Select Option Type**
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    hint: Text("Select Option"),
                    items: variantOptions.map((option) {
                      return DropdownMenuItem(
                          value: option, child: Text(option));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                        if (value != "Custom") {
                          customOptionName =
                              ""; // تفريغ الاسم عند تغيير الاختيار
                        }
                      });
                    },
                  ),
                ),
              ),
            ),

            // ✅ إذا كان الخيار Custom، أضف TextField لاسم الخيار
            if (selectedOption == "Custom") ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Enter custom option name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      customOptionName = value;
                    });
                  },
                ),
              ),
            ],

            SizedBox(height: 16),

            //  **Grey Divider**
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.grey[200],
            ),

            SizedBox(height: 16),

            //  **Values Input Section**
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Values",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),

            SizedBox(height: 6),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          // **TextField for Entering Values**
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Add value",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  values[index] = text;

                                  // ✅ ضمان أن آخر حقل دائماً يكون فارغ لإضافة قيم جديدة
                                  if (text.isNotEmpty &&
                                      index == values.length - 1) {
                                    values = [...values, ""];
                                  }
                                });
                              },
                            ),
                          ),

                          //  **Delete Button (Only if more than one value exists)**
                          if (values.length > 1)
                            IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  values.removeAt(index);
                                });
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
