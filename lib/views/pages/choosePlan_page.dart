import 'package:flutter/material.dart';
import 'SignStoreOwner_page.dart';

class choosePlanPage extends StatelessWidget {
  final String role;

  const choosePlanPage({Key? key, required this.role}) : super(key: key);

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpStoreOwnerPage(
                      role: role,
                      plan: "Basic",
                    ),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpStoreOwnerPage(
                      role: role,
                      plan: "Premium",
                    ),
                  ),
                );
              },
              isPremium: true, // Set to true for the Premium Plan
            ),
          ],
        ),
      ),
    );
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
    return HoverableCard(
      isPremium: isPremium,
      title: title,
      price: price,
      description: description,
      features: features,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }
}

class HoverableCard extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final String buttonText;
  final VoidCallback onPressed;
  final bool isPremium;

  const HoverableCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonText,
    required this.onPressed,
    this.isPremium = false,
  }) : super(key: key);

  @override
  _HoverableCardState createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("Building HoverableCard");
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          debugPrint("Hover entered");
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          debugPrint("Hover nott entered");
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? (widget.isPremium
                      ? Colors.teal.withOpacity(0.7)
                      : Colors.grey.withOpacity(0.7))
                  : Colors.grey.withOpacity(0.3),
              blurRadius: _isHovered ? 15 : 5,
              spreadRadius: _isHovered ? 5 : 1,
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: widget.isPremium ? Colors.teal : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.isPremium ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      widget.price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.isPremium ? Colors.white : Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isPremium ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.white70),
                ...widget.features.map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: widget.isPremium
                                  ? Colors.white
                                  : Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.isPremium
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.isPremium ? Colors.white : Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(
                          color: widget.isPremium ? Colors.teal : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
