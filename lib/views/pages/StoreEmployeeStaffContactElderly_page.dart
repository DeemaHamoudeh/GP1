import 'package:flutter/material.dart';

class StoreEmployeeStaffContactElderlyPage extends StatefulWidget {
  @override
  _StoreEmployeeStaffContactElderlyPageState createState() => _StoreEmployeeStaffContactElderlyPageState();
}

class _StoreEmployeeStaffContactElderlyPageState extends State<StoreEmployeeStaffContactElderlyPage> {
  List<Map<String, dynamic>> orders = [
    {
      "orderId": "#101",
      "customerName": "AhmadKhalid",
      "date": "Jan 20, 2025",
      "totalPrice": "₪14",
      "status": "Delivered",
      "city": "Nablus",
      "street": "Itihad St.",
      "phone": "0598874130",
      "products": [
        {"name": "hair brush", "quantity": 2, "price": "₪7"},
      ],
    },
    {
      "orderId": "#102",
      "customerName": "AliMohammed",
      "date": "Jan 28, 2025",
      "totalPrice": "₪81",
      "status": "Out for Delivery",
      "city": "Nablus",
      "street": "Rafidia St.",
      "phone": "0567890123",
      "products": [
        {"name": "hair Shampoo", "quantity": 2, "price": "₪10"},
        {"name": "mascara", "quantity": 2, "price": "₪20"},
        {"name": "hair brush", "quantity": 3, "price": "₪7"},
      ],
    },
    {
      "orderId": "#103",
      "customerName": "RaniaJamal",
      "date": "Jan 25, 2025",
      "totalPrice": "₪130",
      "status": "Processing",
      "city": "Ramallah",
      "street": "Al-Manara St.",
      "phone": "0591234567",
      "products": [
        {"name": "hair straightener", "quantity": 1, "price": "₪130"},
      ]
    },
    {
      "orderId": "#104",
      "customerName": "MayarAssaf",
      "date": "Jan 25, 2025",
      "totalPrice": "₪43",
      "status": "Processing",
      "city": "Hebron",
      "street": "Al adel St.",
      "phone": "0593214567",
      "products": [
        {"name": "hair brush", "quantity": 4, "price": "₪7"},
        {"name": "eyebrows gel", "quantity": 1, "price": "₪15"},
      ]
    },
    {
      "orderId": "#105",
      "customerName": "RoaaKhalid",
      "date": "Jan 24, 2025",
      "totalPrice": "₪90",
      "status": "Pending",
      "city": "Ramallah",
      "street": "Al masayef",
      "phone": "0568239456",
      "products": [
        {"name": "nail polish red", "quantity": 2, "price": "₪30"},
        {"name": "nail polish blue", "quantity": 1, "price": "₪30"},
      ],
    },
  ];

  String selectedFilter = "All";
  // Widget _buildEmptyOrdersMessage() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
  //         SizedBox(height: 10),
  //         Text(
  //           "No orders yet",
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black54),
  //         ),
  //         SizedBox(height: 5),
  //         Text(
  //           "Your first order will appear here.",
  //           style: TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Beauty Queen - Store Employee"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       title: Text("Order Management"),
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back, color: Colors.black),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.search, color: Colors.black),
  //           onPressed: () {
  //           },
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         _buildFilterBar(),
  //         Expanded(
  //           child:
  //               _buildEmptyOrdersMessage(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFilterBar() {
    List<String> filters = [
      "All",
      "Pending",
      "Processing",
      "Out for Delivery",
      "Delivered"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SingleChildScrollView(
        // ✅ Allows horizontal scrolling
        scrollDirection: Axis.horizontal, // ✅ Enables side-scrolling
        child: Row(
          children: filters.map((filter) {
            return Padding(
              padding:
                  EdgeInsets.only(right: 8), // ✅ Adds spacing between buttons
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: selectedFilter == filter
                        ? Colors.teal
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: selectedFilter == filter
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    switch (order["status"]) {
      case "Pending":
        statusColor = Colors.orange;
        break;
      case "Processing":
        statusColor = Colors.blue;
        break;
      case "Out for Delivery":
        statusColor = Colors.purple;
        break;
      case "Delivered":
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Order ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order["orderId"],
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order["status"],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),

            // ✅ Customer Name, Phone & Date
            Text("Customer: ${order["customerName"]}",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Text("Phone: ${order["phone"]}",
                style: TextStyle(color: Colors.grey[800], fontSize: 14)),
            Text("Date: ${order["date"]}",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),

            SizedBox(height: 8),

            // ✅ Address
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal, size: 18),
                SizedBox(width: 5),
                Text("${order["city"]}, ${order["street"]}",
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),

            SizedBox(height: 10),

            // ✅ Displaying Products
            Text("Products:", style: TextStyle(fontWeight: FontWeight.bold)),

            ...(order["products"] ?? []).map<Widget>((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          "${product["name"]} (x${product["quantity"]})",
                          style: TextStyle(fontSize: 14)),
                    ),
                    Text("${product["price"]}", style: TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 10),

            // ✅ Total Price & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ${order["totalPrice"]}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                // ✅ Action Buttons Based on Status
                if (order["status"] == "Pending")
                  _buildActionButton(
                      order, "Start Processing", "Processing", Colors.blue),

                if (order["status"] == "Processing")
                  _buildActionButton(order, "Send to Delivery",
                      "Out for Delivery", Colors.purple),

                if (order["status"] == "Out for Delivery")
                  _buildActionButton(
                      order, "Mark as Delivered", "Delivered", Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      Map<String, dynamic> order, String label, String newStatus, Color color) {
    return ElevatedButton(
      onPressed: () {
        _updateOrderStatus(order, newStatus);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(label),
    );
  }

  void _updateOrderStatus(Map<String, dynamic> order, String newStatus) {
    setState(() {
      order["status"] = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order ${order["orderId"]} marked as $newStatus")),
    );
  }
}
