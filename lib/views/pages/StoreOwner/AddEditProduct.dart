import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final Map<String, dynamic>? existingProduct;

  AddProductPage({this.existingProduct});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      titleController.text = widget.existingProduct!['title'];
      priceController.text = widget.existingProduct!['price'];
      stockController.text = widget.existingProduct!['stock'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existingProduct != null ? "Edit Product" : "Add Product"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField("Product Name", titleController),
            SizedBox(height: 12),
            _buildInputField("Price (\$)", priceController,
                keyboardType: TextInputType.number),
            SizedBox(height: 12),
            _buildInputField("Stock Quantity", stockController,
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    stockController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'price': "\$${priceController.text}",
                    'stock': int.parse(stockController.text),
                    'image': "assets/images/product_placeholder.png",
                  });
                }
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
