import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArrangePage extends StatefulWidget {
  const ArrangePage({super.key});

  @override
  _ArrangePageState createState() => _ArrangePageState();
}

class _ArrangePageState extends State<ArrangePage> {
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
      "package Id": "#101",
      "date": "Jan 23, 2025",
      "status": "Pending",
      "city": "Nablus",
      "Warehouse": "Shelf 1 Warehouse A",
      "packageCount": "10",
      "StoreName": "Shoes Store",
    },
    {
      "package Id": "#102",
      "date": "Jan 23, 2025",
      "status": "Pending",
      "city": "Nablus",
      "Warehouse": "Shelf 2 Warehouse D",
      "packageCount": "5",
      "StoreName": "linda's Store",
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
              title: Text("Arrange Packages"),
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
      case "Pending":
        statusColor = Colors.orange;
        break;
      case "Processing":
        statusColor = Colors.blue;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order["package Id"],
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
            Text("Store: ${order["StoreName"]}",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Text("Packages Count: ${order["packageCount"]}",
                style: TextStyle(color: Colors.grey[800], fontSize: 14)),
            Text("Date: ${order["date"]}",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal, size: 18),
                SizedBox(width: 5),
                Text("${order["city"]}, ${order["Warehouse"]}",
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                    order, "Start Processing", "Processing", Colors.blue),
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
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }

  void _updateOrderStatus(Map<String, dynamic> order, String newStatus) {
    setState(() {
      order["status"] = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Order ${order["package Id"]} marked as $newStatus")),
    );
  }
}
