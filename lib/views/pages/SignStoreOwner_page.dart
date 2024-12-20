import 'package:flutter/material.dart';

class SignUpStoreOwnerPage extends StatelessWidget {
  final String role;
  final String plan;

  const SignUpStoreOwnerPage({
    Key? key,
    required this.role,
    required this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up - $plan Plan"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          "Sign-up form for $role ($plan Plan)",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class SignUpStoreOwnerPage extends StatelessWidget {
//   final String role;

//   const SignUpStoreOwnerPage({Key? key, required this.role}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Wallpaper background
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     "assets/images/logPages/SignUp-Wallpaper.png"), // Add your image here
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // Page content
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 70),
//                   Center(
//                     child: Text(
//                       "Sign Up as $role",
//                       style: const TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Role-specific fields
//                   if (role == "Store Owner") ...[
//                     _buildTextField("Store Name"),
//                     _buildTextField("Store License"),
//                   ] else if (role == "Customer") ...[
//                     _buildTextField("Full Name"),
//                     _buildTextField("Email"),
//                   ] else if (role == "Delivery Personnel") ...[
//                     _buildTextField("Vehicle Type"),
//                     _buildTextField("License Number"),
//                   ],

//                   const SizedBox(height: 20),

//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Add your sign-up logic here
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18.0),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 50,
//                           vertical: 15,
//                         ),
//                       ),
//                       child: const Text(
//                         "Sign Up",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to create a text field with consistent styling
//   Widget _buildTextField(String labelText) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         decoration: InputDecoration(
//           labelText: labelText,
//           labelStyle: const TextStyle(color: Colors.white),
//           filled: true,
//           fillColor: Colors.black.withOpacity(0.5),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//         ),
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
