import 'package:flutter/material.dart';

class PageViewScreen extends StatelessWidget {
  final String title;
  final String content;

  PageViewScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], //  Soft background
      body: Column(
        children: [
          // 🔹 Top Card with Back Button & Title
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white, //  White top bar
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context), //  Go back
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          //Content Full-Width Card
          Container(
            width: double.infinity, //  Full width
            height: 300,
            constraints: BoxConstraints(
                // maxHeight: MediaQuery.of(context).size.height *
                //     0.9, //  Reduced Height (60% of screen)

                ),
            margin:
                EdgeInsets.symmetric(horizontal: 16), //  Add some side margin
            child: Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), //  Slight rounded edges
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
