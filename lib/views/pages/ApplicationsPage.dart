import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List applications = [];

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    final url = Uri.parse('mongodb://localhost:27017/StoreMaster/applications'); // add backend url here
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        applications = jsonDecode(response.body);
      });
    }
  }

  Future<void> _respondToApplication(int id, String response) async {
    final url = Uri.parse('mongodb://localhost:27017/StoreMaster/applications/$id/response'); // add backend url here
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'response': response}),
    );
    _fetchApplications(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Applications')),
      body: ListView.builder(
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          return Card(
            child: ListTile(
              title: Text('${app['applicantName']} applied for ${app['jobPosition']}'),
              subtitle: Text('Status: ${app['status']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _respondToApplication(app['id'], 'Accept'),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => _respondToApplication(app['id'], 'Deny'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
