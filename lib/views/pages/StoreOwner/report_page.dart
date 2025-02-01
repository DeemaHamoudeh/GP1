import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportAnalyticsPage extends StatefulWidget {
  const ReportAnalyticsPage({Key? key})
      : super(key: key); // Ensure the const keyword is here

  @override
  _ReportAnalyticsPageState createState() => _ReportAnalyticsPageState();
}

class _ReportAnalyticsPageState extends State<ReportAnalyticsPage> {
  List<Map<String, dynamic>> orders = [
    {
      "orderId": "#1001",
      "customerName": "Sarah Ahmad",
      "date": "Jan 23, 2025",
      "totalPrice": 80,
      "status": "Pending",
      "products": [
        {"name": "Vitamin C Serum", "quantity": 2, "price": 40},
      ],
    },
    {
      "orderId": "#1002",
      "customerName": "Omar Khaled",
      "date": "Jan 23, 2025",
      "totalPrice": 50,
      "status": "Pending",
      "products": [
        {"name": "RevitaHair Shampoo", "quantity": 2, "price": 25},
      ],
    },
    {
      "orderId": "#1003",
      "customerName": "Lina Zayed",
      "date": "Jan 20, 2025",
      "totalPrice": 95,
      "status": "Out for Delivery",
      "products": [
        {"name": "Vitamin C Serum", "quantity": 1, "price": 40},
        {"name": "RevitaHair Shampoo", "quantity": 1, "price": 25},
        {"name": "BodyGlow Cream", "quantity": 1, "price": 30},
      ],
    },
  ];
  Widget _buildEmptyReportMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "No reports available yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            "Reports will be generated once you start receiving orders.",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalSales =
        orders.fold(0, (sum, order) => sum + (order["totalPrice"] as int));

    double avgOrderValue = totalSales / orders.length;
    Map<String, int> productSales = {};
    Map<String, int> orderStatusCount = {
      "Pending": 0,
      "Processing": 0,
      "Out for Delivery": 0,
      "Delivered": 0,
    };

    for (var order in orders) {
      orderStatusCount[order["status"]] =
          (orderStatusCount[order["status"]] ?? 0) + 1;

      for (var product in order["products"]) {
        productSales[product["name"]] =
            (productSales[product["name"]] ?? 0) + (product["quantity"] as int);
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Report & Analytics"), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildEmptyReportMessage(),
        // child: ListView(
        //   children: [
        //     _buildSummaryCard("Total Sales this month", "₪$totalSales"),
        //     SizedBox(height: 20),
        //     _buildSummaryCard(
        //         "Average Order Value", "₪${avgOrderValue.toStringAsFixed(2)}"),
        //     SizedBox(height: 20),
        //     _buildOrderStatusPieChart(orderStatusCount),
        //     SizedBox(height: 20),
        //     _buildTopSellingProductsChart(productSales),
        //     SizedBox(height: 40),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700])),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.teal)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusPieChart(Map<String, int> orderStatusCount) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Status Overview",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700])),
            SizedBox(
                height: 200,
                child: PieChart(PieChartData(
                  sections: orderStatusCount.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: "${entry.key} (${entry.value})",
                      color: _getStatusColor(entry.key),
                      radius: 60,
                    );
                  }).toList(),
                ))),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingProductsChart(Map<String, int> productSales) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Top Selling Products",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700])),
            SizedBox(
              height: 300, // Increased height for better label visibility
              child: BarChart(
                BarChartData(
                  barGroups: productSales.entries.map((entry) {
                    return BarChartGroupData(
                      x: productSales.keys.toList().indexOf(entry.key),
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: Colors.teal,
                          width: 25, // Adjusted width for better spacing
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text("${value.toInt()}",
                              style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          List<String> productNames =
                              productSales.keys.toList();
                          if (value.toInt() >= 0 &&
                              value.toInt() < productNames.length) {
                            return Transform.rotate(
                              angle: -0.5, // Rotating text to avoid overlap
                              child: Text(
                                productNames[value.toInt()],
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return Container();
                        },
                        reservedSize: 60, // Increased space for rotated labels
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Processing":
        return Colors.blue;
      case "Out for Delivery":
        return Colors.purple;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
