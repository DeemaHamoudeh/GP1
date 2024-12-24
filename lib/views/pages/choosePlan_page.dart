import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignStoreOwner_page.dart';
import 'SignUpOwnerElderly_page.dart';

class choosePlanPage extends StatefulWidget {
  final String role;

  const choosePlanPage({Key? key, required this.role}) : super(key: key);

  @override
  _choosePlanPageState createState() => _choosePlanPageState();
}

class _choosePlanPageState extends State<choosePlanPage> {
  String? userStatus;

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStatus = prefs.getString('user_status') ?? 'none';
    });
    debugPrint("User status loaded: $userStatus");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Select a Plan",
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              title: "Basic Plan",
              price: "Free",
              description:
                  "Get started with essential features for building and managing your store.",
              features: [
                "Store Setup",
                "Product Management",
                "Order Tracking",
                "Basic Analytics",
                "Standard Customer Support"
              ],
              buttonText: "Start with Basic Plan",
              onPressed: () {
                _navigateToNextPage(context, plan: "Basic");
              },
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              title: "Premium Plan",
              price: "\$29/month",
              description:
                  "Unlock advanced features to grow your store and access warehouses.",
              features: [
                "All Basic Plan features",
                "Warehouse Access",
                "Advanced Analytics",
                "Priority Customer Support",
                "Unlimited Product Listings"
              ],
              buttonText: "Upgrade to Premium",
              onPressed: () {
                _navigateToNextPage(context, plan: "Premium");
              },
              isPremium: true, // Set to true for the Premium Plan
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context, {required String plan}) {
    if (userStatus == 'elderly') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpStoreOwnerPageElderly(
            role: widget.role,
            plan: plan,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpStoreOwnerPage(
            role: widget.role,
            plan: plan,
          ),
        ),
      );
    }
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required String buttonText,
    required VoidCallback onPressed,
    bool isPremium = false, // Add a parameter to distinguish plans
  }) {
    return Card(
      elevation: isPremium ? 8.0 : 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPremium ? Colors.blue : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ...features.map((feature) => ListTile(
                  leading: const Icon(Icons.check, color: Colors.green),
                  title: Text(feature),
                )),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPremium ? Colors.blue : Colors.green,
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
