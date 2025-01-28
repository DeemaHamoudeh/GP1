import 'package:flutter/material.dart';

class AddNewPage extends StatefulWidget {
  final Map<String, String>? existingPage;

  AddNewPage({this.existingPage});

  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingPage != null) {
      titleController.text = widget.existingPage!['title']!;
      contentController.text = widget.existingPage!['content']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background like Shopify
      appBar: AppBar(
        title: Text(widget.existingPage != null ? "Edit Page" : "Add New Page"),
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
            SizedBox(height: 20),
            // 🔹 Title Input Field (WITH BORDER)
            _buildBorderedInputField("Title", titleController),

            SizedBox(height: 40),

            // 🔹 Content Label
            Text("Content",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            SizedBox(height: 8),

            // Large Content Input Field (WITH BORDER)
            Expanded(
              child: _buildBorderedInputField(
                  "Enter content here...", contentController,
                  isLarge: true),
            ),

            SizedBox(height: 16),

            //  Full-Width Save Button
            _buildFullWidthButton("Save", Colors.teal, () {
              if (titleController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'content': contentController.text,
                });
              }
            }),

            if (widget.existingPage != null) ...[
              SizedBox(height: 8),
              _buildFullWidthButton("Delete", Colors.red, () {
                Navigator.pop(context, "delete");
              }),
            ],
          ],
        ),
      ),
    );
  }

  // 🔹 Text Field with BORDER
  Widget _buildBorderedInputField(
      String label, TextEditingController controller,
      {bool isLarge = false}) {
    return TextField(
      controller: controller,
      maxLines: isLarge
          ? 8
          : 1, // 👈 Set max lines to limit height (6 lines for content)
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  // 🔹 Full-Width Button
  Widget _buildFullWidthButton(
      String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
