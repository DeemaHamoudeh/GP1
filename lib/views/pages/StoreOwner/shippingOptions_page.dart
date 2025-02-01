import 'package:flutter/material.dart';

class ShippingOptionsPage extends StatelessWidget {
  final List<Map<String, String>> shippingOptions = [
    {
      "name": "Palestine Post",
      "type": "Locally 🇵🇸",
      "duration": "5-7 days",
      "cost": "\₪15"
    },
    {
      "name": "Aramex Palestine",
      "type": "Locally 🇵🇸",
      "duration": "3-5 days",
      "cost": "\₪18"
    },
    {
      "name": "Wasel Express",
      "type": "Locally 🇵🇸",
      "duration": "2-4 days",
      "cost": "\₪22"
    },
    {
      "name": "SpeedEx",
      "type": "Locally 🇵🇸",
      "duration": "1-3 days",
      "cost": "\₪25"
    },
    {
      "name": "DHL",
      "type": "International 🌍",
      "duration": "7-10 days",
      "cost": "\₪70"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a Shipping Company")),
      body: ListView(
        children: [
          ...shippingOptions.map((option) {
            return ListTile(
              title: Text(option["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  "${option["type"]}  •  ⏳ ${option["duration"]}  •  💰 ${option["cost"]}"),
              trailing: Icon(Icons.local_shipping, color: Colors.teal),
              onTap: () {
                Navigator.pop(context, {
                  "name": option["name"],
                  "duration": option["duration"],
                  "cost": option["cost"],
                });
              },
            );
          }).toList(),

          // ✅ خيار "إضافة شركة جديدة"
          ListTile(
            title:
                Text("Add a new company", style: TextStyle(color: Colors.blue)),
            trailing: Icon(Icons.add, color: Colors.blue),
            onTap: () => Navigator.pop(context, "add_new"),
          ),
        ],
      ),
    );
  }
}
