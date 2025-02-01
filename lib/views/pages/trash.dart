import 'package:flutter/material.dart';

class StoreEmployeeStaffContactElderlyPage extends StatefulWidget {
  const StoreEmployeeStaffContactElderlyPage({Key? key}) : super(key: key);

  @override
  _StoreEmployeeStaffContactElderlyPageState createState() => _StoreEmployeeStaffContactElderlyPageState();
}

class _StoreEmployeeStaffContactElderlyPageState extends State<StoreEmployeeStaffContactElderlyPage> {
  List<Map<String, String>> customerOrders = [
    {"product": "Laptop", "customerName": "Lamar Taylor", "number of products ordered": "1"},
    {"product": "Mobile Phone", "customerName": "Linda Nabulsi", "number of products ordered": "3"},
  ];

  List<bool> orderChecked = [false, false];
  List<Map<String, String>> packages = [
    {"id": "1", "warehouse": "Warehouse A", "location": "Nablus"},
    {"id": "2", "warehouse": "Warehouse H", "location": "Ramallah"},
  ];

  final TextEditingController storageLocationController = TextEditingController();
  final TextEditingController numOfPackagesController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  void _sendToStaff() {
    setState(() {
      // Remove checked orders
      for (int i = orderChecked.length - 1; i >= 0; i--) {
        if (orderChecked[i]) {
          customerOrders.removeAt(i);
          orderChecked.removeAt(i);
        }
      }
      // Check if there are no more orders
      if (customerOrders.isEmpty) {
        customerOrders.add({"product": "No more orders to show", "customerName": "", "number of products ordered": ""});
      }
    });
  }

  void _arrangePackages() {
    // Handle sending package information to staff
    final storageLocation = storageLocationController.text;
    final numOfPackages = numOfPackagesController.text;
    final storeName = storeNameController.text;
    final dueDate = dueDateController.text;

    if (storageLocation.isNotEmpty &&
        numOfPackages.isNotEmpty &&
        storeName.isNotEmpty &&
        dueDate.isNotEmpty) {
      // Process and send to staff
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Packages info sent to staff")),
      );
      // Reset package details
      storageLocationController.clear();
      numOfPackagesController.clear();
      storeNameController.clear();
      dueDateController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/logPages/wall3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Store Employee\nStaff Contact\nMike's Store",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hello, Kinda",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // Prepare Orders Section
                const Text(
                  "Prepare Orders",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: customerOrders.length,
                    itemBuilder: (context, index) {
                      return customerOrders[index]["product"] == "No more orders to show"
                          ? const ListTile(title: Text("No more orders to show", style: TextStyle(color: Colors.black)))
                          : CheckboxListTile(
                              title: Text(
                                "${customerOrders[index]["product"]} - ${customerOrders[index]["customerName"]} (${customerOrders[index]["number of products ordered"]})",
                                style: const TextStyle(color: Colors.black),
                              ),
                              value: orderChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  orderChecked[index] = value!;
                                });
                              },
                            );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _sendToStaff,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text("Send to Staff"),
                ),
                const SizedBox(height: 40),

                // Arrange Packages Section
                const Text(
                  "Arrange Packages",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Package ${package['id']}: ${package['warehouse']}",
                            style: const TextStyle(color: Colors.black)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: storageLocationController,
                          decoration: const InputDecoration(
                            labelText: 'Storage Location',
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color(0xB3FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: numOfPackagesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Number of Packages',
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color(0xB3FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: storeNameController,
                          decoration: const InputDecoration(
                            labelText: 'Store Name',
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color(0xB3FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: dueDateController,
                          decoration: const InputDecoration(
                            labelText: 'Due Date',
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color(0xB3FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _arrangePackages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text("Send to Staff"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}