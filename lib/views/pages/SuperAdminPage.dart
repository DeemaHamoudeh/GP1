import 'package:flutter/material.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  _SuperAdminPageState createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  List<String> filters = ["All", "Store Owner", "Customer", "Staff", "Store Employee", "Stores"];
  String selectedFilter = "All";

  List<Map<String, dynamic>> staff = [
    {
      "username": "HosamMontasir",
      "phone": "0567890123",
      "employeeId": "85236",
      "disability": "None",
      "position": "Delivery Tasks",
      "email": "h.mon@gmail.com",
      "role": "Staff",
    },
    {
      "username": "ramihasan",
      "phone": "0599635522",
      "employeeId": "78290",
      "disability": "Low_Vision",
      "position": "Arrange Orders",
      "email": "rami.hasan@gmail.com",
      "role": "Staff",
    },
    {
      "username": "rama",
      "phone": "0598746328",
      "employeeId": "98006",
      "disability": "colorblind",
      "position": "Delivery Tasks",
      "email": "r.rama@gmail.com",
      "role": "Staff",
    },
    {
      "username": "kinda",
      "phone": "0598749563",
      "employeeId": "65223",
      "disability": "colorblind",
      "position": "Arrange Orders",
      "email": "kinda11@gmail.com",
      "role": "Staff",
    },
    {
      "username": "ibraheem",
      "phone": "0569832641",
      "employeeId": "38765",
      "disability": "colorblind",
      "position": "Prepare Orders",
      "email": "ibraheem2005@gmail.com",
      "role": "Staff",
    },

  ];

/////////////////////////////////////////////////////////////////////////////////////////////

  List<Map<String, dynamic>> storeEmployees = [
    {
      "username": "AliJaber",
      "phone": "0598765432",
      "email": "ali@gmail.com",
      "cv": "ali_cv.pdf",
      "storename":"Mike's Store",
      "disability": "None",
      "role": "Store Employee",
    },
    {
      "username": "Leen",
      "phone": "0591615357",
      "email": "m.leen@gmail.com",
      "cv": "I'm good at ordering management",
      "storename":"Palestine Store",
      "disability": "elderly",
      "role": "Store Employee",
    },
    {
      "username": "Ahmed",
      "phone": "0597373534",
      "email": "ahmed@gmail.com",
      "cv": "ahmed.pdf",
      "storename":"linda's Store",
      "disability": "low_vision",
      "role": "Store Employee",
    },
  ];

/////////////////////////////////////////////////////////////////////////////////////////////

  List<Map<String, dynamic>> storeOwners = [
    {
      "username": "KhaledIbrahim",
      "storename": "beauty",
      "phone": "0565432198",
      "email": "khaled@gmail.com",
      "disability": "None",
      "city": "hebron",
      "role": "Store Owner",
      "ispaid": "no",
    },
    {
      "username": "ferasisam",
      "storename": "localBeauty",
      "phone": "0599223350",
      "email": "ferasisam@gmail.com",
      "disability": "None",
      "city": "nablus",
      "role": "Store Owner",
      "ispaid": "no",
    },
    {
      "username": "arees",
      "storename": "Palestine Store",
      "phone": "0596644283",
      "email": "n.arees@gmail.com",
      "city": "ramallah",
      "disability": "colorblind",
      "role": "Store Owner",
      "ispaid": "yes",
    },
    {
      "username": "linda",
      "storename": "linda's Store",
      "phone": "0598523283",
      "email": "linda.lin@gmail.com",
      "city": "Nablus",
      "disability": "elderly",
      "role": "Store Owner",
      "ispaid": "yes",
    },
    {
      "username": "sami",
      "storename": "Shoes Store",
      "phone": "0568236409",
      "city": "Nablus",
      "email": "sami1970@gmail.com",
      "disability": "elderly",
      "role": "Store Owner",
      "ispaid": "yes",
    },
    {
      "username": "aliAhmad",
      "storename": "CozyCorner",
      "phone": "059334451",
      "city": "jenin",
      "email": "aliAhmad@personal.example2.com",
      "disability": "None",
      "role": "Store Owner",
      "ispaid": "yes",
    },
  ];
/////////////////////////////////////////////////////////////////////////////////////////////

List<Map<String, dynamic>> stores = [
    {
      "storename": "beauty",
      "storeowner": "KhaledIbrahim",
      "email": "khaled@gmail.com",
      "city": "hebron",
      "country":"palestine",
      "ispaid": "no",
      "averageordervalue": "₪30",
      "totalsales": "₪165",
      "topsellingproduct":"hair mist",
      "topsellingcategories": "Hair Care",
    },
    {
      "storename": "localBeauty",
      "storeowner": "ferasisam",
      "email": "ferasisam@gmail.com",
      "city": "nablus",
      "country":"palestine",
      "ispaid": "no",
      "averageordervalue": "₪76.67",
      "totalsales": "₪230",
      "topsellingproduct":"To-Me Anti-Dandruff Hair Shampoo",
      "topsellingcategories": "Skin Care",
    },
    {
      "storename": "Palestine Store",
      "storeowner": "arees",
      "email": "n.arees@gmail.com",
      "city": "ramallah",
      "country":"palestine",
      "ispaid": "yes",
      "averageordervalue": "₪55.97",
      "totalsales": "₪250",
      "topsellingproduct":"Mug 2",
      "topsellingcategories": "Home & Living",
    },
    {
      "storename": "linda's Store",
      "storeowner": "linda",
      "email": "linda.lin@gmail.com",
      "city": "Nablus",
      "country":"palestine",
      "ispaid": "yes",
      "averageordervalue": "₪40",
      "totalsales": "₪300",
      "topsellingproduct":"monopoly",
      "topsellingcategories": "Toys & Games",
    },
    {
      "storename": "Shoes Store",
      "storeowner": "sami",
      "email": "sami1970@gmail.com",
      "city": "Nablus",
      "country":"palestine",
      "ispaid": "yes",
      "averageordervalue": "₪70",
      "totalsales": "₪950",
      "topsellingproduct":"shoes 5",
      "topsellingcategories": "Sports & Outdoors",
    },
    {
      "storename": "CozyCorner",
      "storeowner": "aliAhmad",
      "email": "aliAhmad@personal.example2.com",
      "city": "jenin",
      "country":"palestine",
      "ispaid": "yes",
      "averageordervalue": "₪57.50",
      "totalsales": "₪115",
      "topsellingproduct":"scented candies",
      "topsellingcategories": "Other",
    },
  ];


/////////////////////////////////////////////////////////////////////////////////////////////

  List<Map<String, dynamic>> customers = [
    {
      "username": "AliSaed",
      "phone": "0567890123",
      "email": "Ali.saed@gmail.com",
      "disability": "None",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "AhmadKhalid",
      "phone": "0598874130",
      "email": "ahmad.kh@gmail.com",
      "disability": "colorblind",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "LamaIbrahim",
      "phone": "0591235467",
      "email": "Ibrahim.Lama@gmail.com",
      "disability": "elderly",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "AmeerAhmed",
      "phone": "0591234567",
      "email": "a.ahmed@gmail.com",
      "disability": "elderly",
      "city": "Ramallah",
      "role": "Customer",
    },
    {
      "username": "AliMohammed",
      "phone": "0567890123",
      "email": "Ali.Ahmed@gmail.com",
      "city": "Nablus",
      "disability": "None",
      "role": "Customer",
    },
    {
      "username": "RaniaJamal",
      "phone": "0591235467",
      "email": "j.rania@gmail.com",
      "disability": "low_vision",
      "city": "Ramallah",
      "role": "Customer",
    },
    {
      "username": "MayarAssaf",
      "phone": "0593214567",
      "email": "m.assaf@gmail.com",
      "disability": "colorblind",
      "city": "Hebron",
      "role": "Customer",
    },
    {
      "username": "Roaa Khalid",
      "phone": "0568239456",
      "email": "roaakhalid2@gmail.com",
      "disability": "None",
      "city": "Ramallah",
      "role": "Customer",
    },
    {
      "username": "HosamMasri",
      "phone": "0565590123",
      "email": "hosamasri@gmail.com",
      "disability": "None",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "MohammedAhmed",
      "phone": "0598765002",
      "email": "mohammed.ahmed11@gmail.com",
      "disability": "None",
      "city": "ramallah",
      "role": "Customer",
    },
    {
      "username": "MiraJalal",
      "phone": "0598777750",
      "email": "mirajalal@gmail.com",
      "disability": "None",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "SamerKhaled",
      "phone": "0592112251",
      "email": "khaledsamer@gmail.com",
      "disability": "None",
      "city": "Talkurm",
      "role": "Customer",
    },
    {
      "username": "SarahAhmad",
      "phone": "0591234567",
      "email": "SarahAhmad@gmail.com",
      "disability": "None",
      "city": "Ramallah",
      "role": "Customer",
    },
    {
      "username": "OmarKhaled",
      "phone": "0598765432",
      "email": "OmarKhaled@gmail.com",
      "disability": "None",
      "city": "Nablus",
      "role": "Customer",
    },
    {
      "username": "LinaZayed",
      "phone": "0567890123",
      "email": "LinaZayed@gmail.com",
      "disability": "None",
      "city": "Hebron",
      "role": "Customer",
    },
  ];

  void _deleteUser(List<Map<String, dynamic>> list, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}


  void _sendEmail(String email) {
  TextEditingController messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Send Email"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Write your message to $email:"),
            SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your message here...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String message = messageController.text.trim();
              if (message.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email sent to $email")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Message cannot be empty")),
                );
              }
            },
            child: Text("Send", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}


  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: selectedFilter == filter,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

   List<Map<String, dynamic>> _getFilteredUsers() {
    if (selectedFilter == "All") {
      return [...staff, ...storeEmployees, ...storeOwners, ...customers, ...stores];
    } else if (selectedFilter == "Staff") {
      return staff;
    } else if (selectedFilter == "Store Employee") {
      return storeEmployees;
    } else if (selectedFilter == "Store Owner") {
      return storeOwners;
    }else if (selectedFilter == "Stores") {
      return stores;
    } else {
      return customers;
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user, List<Map<String, dynamic>> list, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.containsKey("username"))
              Text(user["username"],  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (user.containsKey("storename"))
              Text(user["storename"],  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Role: ${user["role"]}", style: TextStyle(color: Colors.grey[800])),
            Text("Phone: ${user["phone"]}", style: TextStyle(color: Colors.purple[800])),
      //     "averageordervalue": "₪55.97",
      // "totalsales": "₪250",
      // "topsellingproduct":"Mug 2",
      // "topsellingcategories": "Home & Living",
            if (user.containsKey("employeeId"))
              Text("Employee ID: ${user["employeeId"]}", style: TextStyle(color: Colors.orange[800])),
            if (user.containsKey("city"))
              Text("City: ${user["city"]}", style: TextStyle(color: Colors.lime[800])),
            if (user.containsKey("country"))
              Text("Country: ${user["country"]}", style: TextStyle(color: Colors.teal[800])),
            if (user.containsKey("position"))
              Text("Position: ${user["position"]}", style: TextStyle(color: Colors.grey[800])),
            if (user.containsKey("averageordervalue"))
              Text("Average Order Value: ${user["averageordervalue"]}", style: TextStyle(color: Colors.lightBlue[800])),
            if (user.containsKey("totalsales"))
              Text("Total Sales: ${user["totalsales"]}", style: TextStyle(color: Colors.lightBlue[800])),
            if (user.containsKey("topsellingproduct"))
              Text("Top Selling Product: ${user["topsellingproduct"]}", style: TextStyle(color: Colors.lightBlue[800])),
            if (user.containsKey("topsellingcategories"))
              Text("Top Selling Categories: ${user["topsellingcategories"]}", style: TextStyle(color: Colors.lightBlue[800])),
            if (user.containsKey("email"))
              Text("Email: ${user["email"]}", style: TextStyle(color: Colors.blue)),
            if (user.containsKey("ispaid"))
              Text("is Paid: ${user["ispaid"]}", style: TextStyle(color: Colors.orange)),
            if (user.containsKey("cv"))
              Text("CV: ${user["cv"]}", style: TextStyle(color: Colors.pink)),
              if (user.containsKey("storename"))
              Text("Store Name: ${user["storename"]}", style: TextStyle(color: Colors.green)),
            Text("Disability: ${user["disability"]}", style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _deleteUser(list, index),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete"),
                ),
                if (user.containsKey("email"))
                  ElevatedButton(
                    onPressed: () => _sendEmail(user["email"]),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text("Send Email"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Admin Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterBar(),
            SizedBox(height: 10),
            ..._getFilteredUsers().asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> user = entry.value;
              return _buildUserCard(user, _getFilteredUsers(), index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Widget _buildSection(String title, List<Map<String, dynamic>> list) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
  //       SizedBox(height: 10),
  //       if (list.isEmpty)
  //         Text("No records available", style: TextStyle(color: Colors.grey)),
  //       ...list.asMap().entries.map((entry) => _buildUserCard(entry.value, list, entry.key)).toList(),
  //       SizedBox(height: 20),
  //     ],
  //   );
  // }
}
