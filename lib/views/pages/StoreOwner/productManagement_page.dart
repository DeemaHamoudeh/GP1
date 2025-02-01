import 'package:flutter/material.dart';
//import 'AddEditProduct.dart';
import 'addProduct_page.dart';

class ProductManagementPage extends StatefulWidget {
  final String? token;

  ProductManagementPage({Key? key, required this.token}) : super(key: key);

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  List<Map<String, dynamic>> products = [
    {
      "title": "T-shirt",
      "price": "\₪50",
      "stock": 10,
      "image": "assets/images/shop/T-shirt.png",
    },
    {
      "title": "pants",
      "price": "\₪20",
      "stock": 5,
      "image": "assets/images/shop/pants.png",
    },
    {
      "title": "white shirt",
      "price": "\₪30",
      "stock": 5,
      "image": "assets/images/shop/white-shirt.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Product Management"),
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
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddProduct();
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(product["image"], width: 80, height: 80),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product["title"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(product["price"],
                      style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 4),
                  Text("Stock: ${product["stock"]}",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    _navigateToEditProduct(product, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    _deleteProduct(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddProductPage(token: widget.token)),
    );

    if (result != null) {
      setState(() {
        products.add(result);
      });
    }
  }

  void _navigateToEditProduct(Map<String, dynamic> product, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddProductPage(token: widget.token)),
    );

    if (result != null) {
      setState(() {
        products[index] = result;
      });
    }
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }
}
