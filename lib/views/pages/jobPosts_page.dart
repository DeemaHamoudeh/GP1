import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobPostsPage extends StatefulWidget {
  const JobPostsPage({super.key});

  @override
  State<JobPostsPage> createState() => _JobPostsPageState();
}

class _JobPostsPageState extends State<JobPostsPage> {
  List<Map<String, String>> jobPosts = [];
  String? userStatus;
  String? colorBlindType;
    void _showConfirmationMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text(
          "You applied for this job. Your information has been submitted successfully! Please wait for an approval message via email.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadColorBlindType();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStatus = prefs.getString('user_status') ?? 'none';
      _populateJobPosts();
    });
  }

  Future<void> _loadColorBlindType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  ColorFilter _getColorFilter(String? type) {
    switch (type) {
      case 'protanomaly': // Reduced sensitivity to red
        return const ColorFilter.mode(
          Color(0xFFFFD1DC), // Light pink to enhance red
          BlendMode.modulate,
        );
      case 'deuteranomaly': // Reduced sensitivity to green
        return const ColorFilter.mode(
          Color(0xFFDAF7A6), // Light green to enhance green
          BlendMode.modulate,
        );
      case 'tritanomaly': // Reduced sensitivity to blue
        return const ColorFilter.mode(
          Color(0xFFA6E3FF), // Light cyan to enhance blue
          BlendMode.modulate,
        );
      case 'protanopia': // Red-blind
        return const ColorFilter.mode(
          Color(0xFFFFA07A), // Light salmon to compensate for red blindness
          BlendMode.modulate,
        );
      case 'deuteranopia': // Green-blind
        return const ColorFilter.mode(
          Color(0xFF98FB98), // Pale green to compensate for green blindness
          BlendMode.modulate,
        );
      case 'tritanopia': // Blue-blind
        return const ColorFilter.mode(
          Color(0xFFADD8E6), // Light blue to compensate for blue blindness
          BlendMode.modulate,
        );
      case 'achromatopsia': // Total color blindness
        return const ColorFilter.mode(
          Color(0xFFD3D3D3), // Light gray to provide neutral contrast
          BlendMode.modulate,
        );
      case 'achromatomaly': // Reduced total color sensitivity
        return const ColorFilter.mode(
          Color(0xFFEED5D2), // Light beige for better overall contrast
          BlendMode.modulate,
        );
      default:
        return const ColorFilter.mode(
          Colors.transparent, // No filter for 'none' or unrecognized type
          BlendMode.color,
        );
    }
  }

  void _populateJobPosts() {
    jobPosts = [
      {"title": "Cashier", "description": "Handle daily cash transactions."},
      {"title": "Stock Manager", "description": "Manage inventory stock."},
    ];

    if (userStatus == "elderly") {
      jobPosts.addAll([
        {"title": "Store Greeter", "description": "Welcome customers at the door."},
        {"title": "Inventory Assistant", "description": "Help with inventory sorting."},
      ]);
    } else if (userStatus == "low_vision") {
      jobPosts.addAll([
        {"title": "Call Center Agent", "description": "Assist customers over the phone."},
        {"title": "Data Entry", "description": "Input data into systems with guidance."},
      ]);
    } else if (userStatus == "colorblind") {
      jobPosts.addAll([
        {"title": "Administrative Assistant", "description": "Assist with office tasks."},
        {"title": "Logistics Coordinator", "description": "Coordinate shipments and deliveries."},
      ]);
    } else if (userStatus == "none") {
      jobPosts.addAll([
        {"title": "Marketing Assistant", "description": "Support marketing campaigns."},
        {"title": "Customer Support", "description": "Help customers with their issues."},
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Posts"),
        backgroundColor: Colors.blue,
      ),
      body: ColorFiltered(
        colorFilter: colorFilter,
        child: userStatus == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: jobPosts.length,
                itemBuilder: (context, index) {
                  final job = jobPosts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(job["title"]!),
                      subtitle: Text(job["description"]!),
                      trailing: ElevatedButton(
                        onPressed: () {
                          debugPrint("${job["title"]} selected.");
                          _showConfirmationMessage();
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
