import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../controllers/userController.dart'; // Import UserController
import '../../../../controllers/storeController.dart';

Future<void> _markStepAsCompleted() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("store_name_added", true);
}

class StoreDetailsPage extends StatefulWidget {
  final String? token;
  const StoreDetailsPage({Key? key, required this.token}) : super(key: key);

  @override
  _StoreDetailsPageState createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  String storeName = "My Store";
  String storePhone = "+970 599 123 456";
  String storeLogo = "Tap to edit logo";
  String storeEmail = "store@example.com";
  String storeCity = "Enter City";
  String storeCountry = "Enter Country";
  String storeZip = "Enter Zip Code";
  String storeAddress = "Enter Address"; // Add this line

  late String? token;
  String? storeId;
  List<String> _categories = [
    "Fashion & Apparel",
    "Electronics & Gadgets",
    "Food & Beverage",
    "Health & Fitness",
    "Handmade & Crafts",
    "Home & Living",
    "Beauty & Personal Care",
    "Toys & Kids",
    "Automotive & Accessories",
    "Books & Stationery"
  ];

  List<String> _selectedCategories = []; // Stores selected categories
  TextEditingController storeCityController =
      TextEditingController(text: "Enter City");
  TextEditingController storeCountryController =
      TextEditingController(text: "Enter Country");
  TextEditingController storeZipController =
      TextEditingController(text: "Enter Zip Code");
  Map<String, String> originalValues = {};

  final _formKey = GlobalKey<FormState>();
  Future<void> fetchStoreDetails() async {
    if (token == null || storeId == null) {
      print("❌ Error: Token or Store ID is missing.");
      return;
    }

    try {
      print("go to getStoreDetails");
      final storeController = StoreController();
      final response = await storeController.getStoreDetails(token!, storeId!);
      print("return from getStoreDetails");
      if (response['success']) {
        final storeData = response['data'];

        setState(() {
          storeName = storeData['name'] ?? storeName;
          storePhone = storeData['phone'] ?? storePhone;
          storeLogo = storeData['logo'] ?? storeLogo;
          storeEmail = storeData['email'] ?? storeEmail;

          storeCityController.text =
              storeData['address']?['city'] ?? storeCityController.text;
          storeCountryController.text =
              storeData['address']?['country'] ?? storeCountryController.text;
          storeZipController.text =
              storeData['address']?['zipCode'] ?? storeZipController.text;
        });

        print("✅ Store details loaded successfully.");
      } else {
        print("❌ Failed to fetch store details: ${response['message']}");
      }
    } catch (error) {
      print("❌ Error fetching store details: $error");
    }
  }

  Future<void> _fetchUserInfo() async {
    if (token == null) {
      print("❌ Error: Token is missing.");
      return;
    }

    try {
      final userController = UserController();
      final result = await userController.fetchUserInfo(token!);

      if (result['success']) {
        setState(() {
          storeId = result['data']['additionalDetails']['storeOwnerDetails']
              ['storeIds'][0];
        });

        if (storeId == null) {
          print("❌ Error: Store ID is still null after fetching user info.");
          return;
        }

        print("✅ Store ID retrieved: $storeId");
      } else {
        print("❌ Failed to fetch user info: ${result['message']}");
      }
    } catch (error) {
      print("❌ Error fetching user info: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    token = widget.token; // ✅ Store the token
    print("🔑 StoreDetailsPage received token: $token");
    storeCityController = TextEditingController(text: "Enter City");
    storeCountryController = TextEditingController(text: "Enter Country");
    storeZipController = TextEditingController(text: "Enter Zip Code");

    _fetchUserInfo().then((_) {
      if (storeId != null) {
        print("🚀 Store ID available, fetching store details...");
        fetchStoreDetails();
      } else {
        print("❌ Error: Store ID is still null, skipping fetchStoreDetails()");
      }
    });
  }

  @override
  void dispose() {
    storeCityController.dispose();
    storeCountryController.dispose();
    storeZipController.dispose();
    super.dispose();
  }

  void _pickImage(Function(String) onSave) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onSave(pickedFile.path);
    }
  }

  Future<void> updateStoreDetails() async {
    print("🛠️ Sending updated store details...");

    if (token == null || storeId == null) {
      print("❌ Error: Token or Store ID is missing.");
      return;
    }

    // ✅ Filter only changed fields
    Map<String, dynamic> updatedData = {};

    bool storeNameChanged = storeName != originalValues["name"];
    if (storeNameChanged) updatedData["name"] = storeName;

    String cleanedPhoneNumber = storePhone.trim();
    if (cleanedPhoneNumber != originalValues["phone"]) {
      updatedData["phone"] = cleanedPhoneNumber;
    }

    if (storeLogo != originalValues["logo"]) updatedData["logo"] = storeLogo;

    if (storeCityController.text != originalValues["city"] ||
        storeCountryController.text != originalValues["country"] ||
        storeZipController.text != originalValues["zip"]) {
      updatedData["address"] = {
        "city": storeCityController.text.trim(),
        "country": storeCountryController.text.trim(),
        "zipCode": storeZipController.text.trim(),
      };
    }

    if (updatedData.isEmpty) {
      print("✅ No changes detected. Skipping update.");
      return;
    }

    print("📡 Data being sent: $updatedData");

    try {
      final storeController = StoreController();
      final response = await storeController.updateStoreDetails(
        token!,
        storeId!,
        updatedData, // ✅ Send only changed fields
      );

      if (response['success']) {
        print("✅ Store details updated successfully.");

        final userController = UserController();

        // ✅ **If store name changed, mark step as completed**
        if (storeNameChanged) {
          print("🔄 Store name changed! Marking Step 1 as completed...");
          await userController.updateSetupGuide(token!, 1, true);
          print("✅ Step 1 marked as completed.");
        }

        // ✅ Reload setup guide after update
        await userController.fetchSetupGuide(token!);
        print("✅ Setup guide reloaded.");

        // ✅ **Ensure navigation happens AFTER updates**
        if (mounted) {
          print("🚀 Navigating back to Dashboard...");
          Navigator.pop(context, true); // ✅ This ensures navigation back
        }
      } else {
        print("❌ Failed to update store details: ${response['message']}");
      }
    } catch (error) {
      print("❌ Error updating store details: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[50], // Light gray background
        child: Column(
          children: [
            // Custom Header
            SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Go back
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Store Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48), // Placeholder to center the title
                ],
              ),
            ),
            //  SizedBox(height: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Store Information Card
                      Card(
                        elevation: 2,
                        color: Color(0xFFF8F9FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEditableRow(
                                context: context,
                                label: "Store Name",
                                value: storeName,
                                icon: Icons.edit,
                                onSave: (newValue) {
                                  setState(() {
                                    storeName = newValue;
                                  });
                                },
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildEditableRow(
                                context: context,
                                label: "Store Phone",
                                value: storePhone,
                                icon: Icons.edit,
                                onSave: (newValue) {
                                  setState(() {
                                    storePhone = newValue;
                                  });
                                },
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildEditableRow(
                                context: context,
                                label: "Store Email", // ✅ Added Email Field
                                value: storeEmail,
                                icon: Icons.email,
                                onSave: (newValue) {
                                  setState(() {
                                    storeEmail = newValue;
                                  });
                                },
                              ),
                              Divider(color: Colors.grey[300]),
                              _buildEditableRow(
                                context: context,
                                label: "Store Logo",
                                value: storeLogo,
                                icon: Icons.image,
                                onSave: (newValue) {
                                  setState(() {
                                    storeLogo =
                                        newValue; // Store selected image path
                                  });
                                },
                                isImage:
                                    true, // Tell function to open image picker
                              ),
                              // _buildEditableRow(
                              //   context: context,
                              //   label: "City",
                              //   value: storeCity,
                              //   icon: Icons.location_city,
                              //   onSave: (newValue) =>
                              //       setState(() => storeCity = newValue),
                              // ),
                              // Divider(color: Colors.grey[300]),
                              // _buildEditableRow(
                              //   context: context,
                              //   label: "Country",
                              //   value: storeCountry,
                              //   icon: Icons.public,
                              //   onSave: (newValue) =>
                              //       setState(() => storeCountry = newValue),
                              // ),
                              // Divider(color: Colors.grey[300]),
                              // _buildEditableRow(
                              //   context: context,
                              //   label: "Zip Code",
                              //   value: storeZip,
                              //   icon: Icons.pin_drop,
                              //   onSave: (newValue) =>
                              //       setState(() => storeZip = newValue),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 40),
                      // 🏠 Placeholder for Store Address (To be added later)
                      SizedBox(height: 20),
                      Text(
                        'Store Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),

                      Card(
                        elevation: 2,
                        color: Color(0xFFF8F9FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildEditableTextField(
                                          "City",
                                          storeCityController,
                                          Icons.location_city),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildEditableTextField("Country",
                                          storeCountryController, Icons.public),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                _buildEditableTextField("Zip Code",
                                    storeZipController, Icons.pin_drop),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // Additional fields
                      Text(
                        'Store Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter a brief description of your store',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 50),

                      Text(
                        'Store Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      MultiSelectDialogField(
                        items: _categories
                            .map((category) =>
                                MultiSelectItem<String>(category, category))
                            .toList(),
                        title: Text("Select Store Categories"),
                        buttonText: Text("Choose Categories"),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // chipDisplay: MultiSelectChipDisplay(
                        //   chipColor: Colors.teal,
                        //   textStyle: TextStyle(color: Colors.white),
                        //   onTap: (value) {
                        //     setState(() {
                        //       _selectedCategories.remove(value);
                        //     });
                        //   },
                        // ),
                        onConfirm: (values) {
                          setState(() {
                            _selectedCategories = values.cast<String>();
                          });
                        },
                      ),

                      SizedBox(height: 16),

                      // Display Selected Categories
                      _selectedCategories.isNotEmpty
                          ? Wrap(
                              spacing: 8.0,
                              children: _selectedCategories
                                  .map((category) => Chip(
                                        label: Text(category),
                                        backgroundColor:
                                            Colors.teal.withOpacity(0.2),
                                        deleteIcon:
                                            Icon(Icons.cancel, size: 18),
                                        onDeleted: () {
                                          setState(() {
                                            _selectedCategories
                                                .remove(category);
                                          });
                                        },
                                      ))
                                  .toList(),
                            )
                          : Text("No categories selected"),

                      SizedBox(height: 50),
                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print(
                                  "✅ Address fields are valid! Proceeding...");
                              await updateStoreDetails(); // ✅ استدعاء دالة تحديث البيانات
                            } else {
                              print("❌ Validation failed! Fix the errors.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF33B5AB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.0,
                              vertical: 16.0,
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(
      String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Validate while typing
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onTap: () {
        if (controller.text == "Enter City" ||
            controller.text == "Enter Country" ||
            controller.text == "Enter Zip Code") {
          controller.clear(); // Clears placeholder when user taps
        }
      },
      onChanged: (value) {
        setState(() {}); // Update validation in real time
      },
      validator: (value) {
        // ✅ Skip validation if the field hasn't changed
        if (value == originalValues[label.toLowerCase()] ||
            value == "Enter City" ||
            value == "Enter Country" ||
            value == "Enter Zip Code") {
          return null;
        }
        if (label == "Zip Code" &&
            value != null &&
            !RegExp(r'^[a-zA-Z0-9\s-]{4,10}$').hasMatch(value)) {
          return "Enter a valid zip code (4-10 digits)";
        }
        if ((label == "City" || label == "Country") &&
            value != null &&
            !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return "$label should contain only letters";
        }
        if (label == "Store Phone" &&
            value != null &&
            !RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
          return "Enter a valid phone number (10-15 digits)";
        }
        return null;
      },
      keyboardType:
          label == "Zip Code" ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildEditableRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Function(String) onSave,
    bool isImage = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              isImage
                  ? (value.isNotEmpty && File(value).existsSync())
                      ? Image.file(
                          File(value),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          "Tap to upload logo",
                          style: TextStyle(color: Colors.grey),
                        )
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(icon, color: Color(0xFF33B5AB)),
          onPressed: () {
            if (isImage) {
              _pickImage(onSave);
            } else {
              _showEditPopup(context, label, value, onSave);
            }
          },
        ),
      ],
    );
  }

  void _showEditPopup(BuildContext context, String label, String initialValue,
      Function(String) onSave) {
    final TextEditingController controller = TextEditingController();
    controller.text = initialValue;
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $label"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter $label",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "$label cannot be empty";
                }
                if (label == "Store Email" &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return "Enter a valid email address";
                }
                if (label == "Store Phone" &&
                    !RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                  return "Enter a valid phone number (10-15 digits)";
                }
                return null;
              },
              keyboardType: label == "Store Phone"
                  ? TextInputType.phone
                  : label == "Store Email"
                      ? TextInputType.emailAddress
                      : TextInputType.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onSave(controller.text);
                  Navigator.pop(context); // Close the dialog
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF33B5AB),
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
