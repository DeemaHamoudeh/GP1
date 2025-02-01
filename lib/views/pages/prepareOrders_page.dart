import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrepareOrdersPage extends StatefulWidget {
  const PrepareOrdersPage({super.key});
  @override
  _PrepareOrdersPageState createState() => _PrepareOrdersPageState();
}

class _PrepareOrdersPageState extends State<PrepareOrdersPage> {

  String? colorBlindType;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadColorBlindType();
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'None';
    });
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly':
        return const ColorFilter.mode(Color(0xFFFFD1DC), BlendMode.modulate);
      case 'deuteranomaly':
        return const ColorFilter.mode(Color(0xFFDAF7A6), BlendMode.modulate);
      case 'tritanomaly':
        return const ColorFilter.mode(Color(0xFFA6E3FF), BlendMode.modulate);
      case 'protanopia':
        return const ColorFilter.mode(Color(0xFFFFA07A), BlendMode.modulate);
      case 'deuteranopia':
        return const ColorFilter.mode(Color(0xFF98FB98), BlendMode.modulate);
      case 'tritanopia':
        return const ColorFilter.mode(Color(0xFFADD8E6), BlendMode.modulate);
      case 'achromatopsia':
        return const ColorFilter.mode(Color(0xFFD3D3D3), BlendMode.modulate);
      case 'achromatomaly':
        return const ColorFilter.mode(Color(0xFFEED5D2), BlendMode.modulate);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.color);
    }
  }
  List<Map<String, dynamic>> orders = [
    {
      "orderId": "#101",
      "customerName": "HosamMasri",
      "date": "Jan 26, 2025",
      "totalPrice": "₪320",
      "status": "Processing",
      "city": "Nablus",
      "street": "Rafidia St.",
      "phone": "0565590123",
      "products": [
        {"name": "shoes 1", "quantity": 2, "price": "₪70"},
        {"name": "shoes 5", "quantity": 3, "price": "₪60"},
      ],
      "StoreName": "shoes Store",
    },
    {
      "orderId": "#102",
      "customerName": "MohammedAhmed",
      "date": "Jan 26, 2025",
      "totalPrice": "₪80",
      "status": "Processing",
      "city": "ramallah",
      "street": "Al-Madina St.",
      "phone": "0598765002",
      "products": [
        {"name": "Mug 1", "quantity": 1, "price": "₪20"},
        {"name": "Mug 2", "quantity": 2, "price": "₪20"},
        {"name": "Mug 3", "quantity": 1, "price": "₪20"},
      ],
      "StoreName": "Palestine Store",
    },
    {
      "orderId": "#103",
      "customerName": "MiraJalal",
      "date": "Jan 24, 2025",
      "totalPrice": "₪45",
      "status": "Processing",
      "city": "Nablus",
      "street": "OldCity",
      "phone": "0598777750",
      "products": [
        {"name": "scented candles", "quantity": 2, "price": "₪10"},
        {"name": "cozy throws", "quantity": 1, "price": "₪25"},
      ],
      "StoreName": "CozyCorner",
    },
    {
      "orderId": "#104",
      "customerName": "SamerKhaled",
      "date": "Jan 24, 2025",
      "totalPrice": "₪70",
      "status": "Processing",
      "city": "Talkurm",
      "street": "Paris St.",
      "phone": "0592112251",
      "products": [
        {"name": "modern wall clocks", "quantity": 1, "price": "₪70"},
      ],
      "StoreName": "CozyCorner",
    },
  ];
  void _showNotifications(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return ListView(
    //       padding: EdgeInsets.all(16),
    //       children: [
    //         ListTile(
    //           leading: Icon(Icons.shopping_cart, color: Colors.blue),
    //           title: Text("New Order Received"),
    //           subtitle: Text("Order #103 from Lama Ibrahim"),
    //         ),

    //       ],
    //     );
    //   },
    // );

    setState(() {
      notificationCount = 0;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ColorFiltered(
          colorFilter: _getColorFilter(colorBlindType),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Prepare Orders"),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 90, 193, 184),
                  ),
                  onPressed: () {
                    print("🔔 Notification clicked!");
                    _showNotifications(context);
                  },
                  iconSize: 35,
                ),
                if (notificationCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$notificationCount",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            body: Column(
              children: [
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
          ),
        ),
      ),
    );
  }



  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    switch (order["status"]) {
      case "Processing":
        statusColor = Colors.blue;
        break;
      case "Out for Delivery":
        statusColor = Colors.purple;
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
                Text("${order["city"]}, ${order["street"]}, ${order["StoreName"]}",
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ${order["totalPrice"]}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                // ✅ Action Buttons Based on Status
                  _buildActionButton(order, "Send to Delivery", "Out for Delivery", Colors.purple),


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
