import 'package:flutter/material.dart';
import 'registor_page.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  // List of roles and selected role
  final List<Map<String, dynamic>> roles = [
    {'name': 'Employee', 'icon': Icons.work},
    {'name': 'Owner', 'icon': Icons.business},
    {'name': 'App Staff', 'icon': Icons.admin_panel_settings},
    {'name': 'Customer', 'icon': Icons.shopping_cart},
  ];

  String? selectedRole; // Holds the currently selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center( 
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink the column size
          children: [
            
            SizedBox(
              height: 400, // Restrict the height to center the grid nicely
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two boxes per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2, // Adjust aspect ratio of boxes
                ),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final isSelected = selectedRole == role['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = role['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.teal.shade700 : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            role['icon'],
                            size: 50,
                            color: isSelected ? Colors.white : Colors.teal,
                          ),
                          SizedBox(height: 12),
                          Text(
                            role['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm Button
            if (selectedRole != null) // Show confirm button only when role is selected
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
