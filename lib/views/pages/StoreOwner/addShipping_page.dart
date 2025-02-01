import 'package:flutter/material.dart';

class AddShippingPage extends StatefulWidget {
  final Map<String, dynamic>? existingCompany;

  AddShippingPage({this.existingCompany});

  @override
  _AddShippingPageState createState() => _AddShippingPageState();
}

class _AddShippingPageState extends State<AddShippingPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingCompany != null) {
      nameController.text = widget.existingCompany!['name'];
      durationController.text = widget.existingCompany!['duration'].toString();
      costController.text = widget.existingCompany!['cost'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        title: Text(
            widget.existingCompany != null ? "Edit Shipping" : "Add Shipping"),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Company Name", nameController),
            SizedBox(height: 12),
            _buildInputField("Maximum Delivery Time (Days)", durationController,
                keyboardType: TextInputType.number),
            SizedBox(height: 12),
            _buildInputField("Minimum Cost (in currency)", costController,
                keyboardType: TextInputType.number),
            SizedBox(height: 24),

            // 🆕 Button Section
            Column(
              children: [
                if (widget.existingCompany != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, "delete");
                      },
                      child: Text("Delete",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                SizedBox(
                    height: widget.existingCompany != null
                        ? 12
                        : 0), // Adds space only if Delete exists
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          durationController.text.isNotEmpty &&
                          costController.text.isNotEmpty) {
                        Navigator.pop(context, {
                          'name': nameController.text,
                          'duration': int.parse(durationController.text),
                          'cost': int.parse(costController.text),
                        });
                      }
                    },
                    child: Text("Save",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none, // Remove the default border
          ),
        ),
      ),
    );
  }
}
