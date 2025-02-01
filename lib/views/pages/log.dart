// // import '../../../controllers/userController.dart';
// // import 'StoreOwner/dashBoardStoreOwner_page.dart';
// import 'package:flutter/material.dart';
// import 'role_selection_page.dart';
// import 'forgetPassword_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// import 'storeEmployeeconfirm_page.dart';
// import 'StoreEmployeeStaffContactElderly_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _identifierController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String errorMessage = '';
//   final _formKey = GlobalKey<FormState>();
//   String? colorBlindType;
//   bool _isFirstVisit = true;  // Flag to track if it's the first visit

//   @override
//   void initState() {
//     super.initState();
//     _loadColorBlindType();
//     _checkFirstVisit();
//   }

//   Future<void> _loadColorBlindType() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       colorBlindType = prefs.getString('colorblind_type') ?? 'none';
//     });
//   }

//   Future<void> _checkFirstVisit() async {
//     final prefs = await SharedPreferences.getInstance();
//     final firstVisit = prefs.getBool('first_visit') ?? true;
//     setState(() {
//       _isFirstVisit = firstVisit;
//     });

//     if (_isFirstVisit) {
//       await prefs.setBool('first_visit', false);  // Update the flag for next time
//     }
//   }

//   // Future<void> _speak(String text) async {
//   //   final FlutterTts flutterTts = FlutterTts();
//   //   await flutterTts.speak(text);
//   // }

//   ColorFilter _getColorFilter(String? type) {
//     switch (type) {
//       case 'protanomaly':
//         return const ColorFilter.mode(
//           Color(0xFFFFD1DC), // Light pink to enhance red
//           BlendMode.modulate,
//         );
//       case 'deuteranomaly':
//         return const ColorFilter.mode(
//           Color(0xFFDAF7A6), // Light green to enhance green
//           BlendMode.modulate,
//         );
//       case 'tritanomaly':
//         return const ColorFilter.mode(
//           Color(0xFFA6E3FF), // Light cyan to enhance blue
//           BlendMode.modulate,
//         );
//       case 'protanopia':
//         return const ColorFilter.mode(
//           Color(0xFFFFA07A), // Light salmon to compensate for red blindness
//           BlendMode.modulate,
//         );
//       case 'deuteranopia':
//         return const ColorFilter.mode(
//           Color(0xFF98FB98), // Pale green to compensate for green blindness
//           BlendMode.modulate,
//         );
//       case 'tritanopia':
//         return const ColorFilter.mode(
//           Color(0xFFADD8E6), // Light blue to compensate for blue blindness
//           BlendMode.modulate,
//         );
//       case 'achromatopsia':
//         return const ColorFilter.mode(
//           Color(0xFFD3D3D3), // Light gray to provide neutral contrast
//           BlendMode.modulate,
//         );
//       case 'achromatomaly':
//         return const ColorFilter.mode(
//           Color(0xFFEED5D2), // Light beige for better overall contrast
//           BlendMode.modulate,
//         );
//       default:
//         return const ColorFilter.mode(
//           Colors.transparent, // No filter for 'none' or unrecognized type
//           BlendMode.color,
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorFilter = _getColorFilter(colorBlindType);
//     // _speak("login page");

//     // First visit speech logic
//     // if (_isFirstVisit) {
//     //   Future.delayed(Duration.zero, () async {
//     //     await _speak("login page");
//     //   });
//     // } else {
//     //   Future.delayed(Duration.zero, () async {
//     //     await _speak("login page");
//     //     await Future.delayed(const Duration(seconds: 10));
//     //     await _speak("username or email");
//     //     await Future.delayed(const Duration(seconds: 10));
//     //     await _speak("password");
//     //   });
//     // }

//     return GestureDetector(
//       onTap: () async {
//         // Avoid triggering speech on tap if it's already handled
//       },
//       child: Scaffold(
//         body: ColorFiltered(
//           colorFilter: colorFilter, // Apply the color filter here
//           child: Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/logPages/login-wallpaper.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: SafeArea(
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 180),
//                           const Text(
//                             "Welcome!",
//                             style: TextStyle(
//                               fontSize: 39,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 40),

//                           // Username Row
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.teal,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.person,
//                                   color: Colors.white,
//                                   size: 24,
//                                 ),
//                               ),
//                               const SizedBox(width: 15),
//                               Expanded(
//                                 child: Container(
//                                   constraints: const BoxConstraints(maxWidth: 350),
//                                   child: TextField(
//                                     controller: _identifierController,
//                                     style: const TextStyle(color: Colors.black),
//                                     decoration: InputDecoration(
//                                       labelText: "Username or Email",
//                                       labelStyle:
//                                           const TextStyle(color: Colors.black54),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                           vertical: 10, horizontal: 15),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.black45),
//                                         borderRadius: BorderRadius.circular(18.0),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.teal, width: 2),
//                                         borderRadius: BorderRadius.circular(8.0),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 30),

//                           // Password Row
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.teal,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.lock,
//                                       color: Colors.white,
//                                       size: 24,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 15),
//                                   Expanded(
//                                     child: Container(
//                                       constraints:
//                                           const BoxConstraints(maxWidth: 350),
//                                       child: TextField(
//                                         controller: _passwordController,
//                                         obscureText: true,
//                                         style:
//                                             const TextStyle(color: Colors.black),
//                                         decoration: InputDecoration(
//                                           labelText: "Password",
//                                           labelStyle: const TextStyle(
//                                               color: Colors.black54),
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 10,
//                                                   horizontal: 15),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Colors.black45),
//                                             borderRadius:
//                                                 BorderRadius.circular(18.0),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Colors.teal, width: 2),
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               ForgotPasswordPage()),
//                                     );
//                                   },
//                                   child: const Text(
//                                     "Forgot password?",
//                                     style: TextStyle(
//                                       color: Colors.teal,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 40),

//                           if (errorMessage.isNotEmpty)
//                             Text(errorMessage,
//                                 style: const TextStyle(
//                                     color: Colors.red, fontSize: 16)),

//                           // Login Button
//                           ElevatedButton(
//                             onPressed: () {
//                               final username = _identifierController.text.trim();
//                               final password = _passwordController.text.trim();

//                               if (username == "Ahmed" && password == "123456@Aa") {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const EmployeeConfirmWait(),
//                                   ),
//                                 );
//                               } else if (username == "Kinda" && password == "123456@Kk") {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const StoreEmployeeStaffContactElderlyPage(),
//                                   ),
//                                 );
//                               } else {
//                                 setState(() {
//                                   errorMessage = "Invalid credentials";
//                                 });
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: const Size(150, 50),
//                               backgroundColor: Colors.teal,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18.0),
//                               ),
//                             ),
//                             child: const Text(
//                               "Log In",
//                               style:
//                                   TextStyle(fontSize: 20, color: Colors.white),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // Sign Up Text
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => RoleSelectionPage()),
//                               );
//                             },
//                             child: RichText(
//                               text: const TextSpan(
//                                 text: "Don't have an account? ",
//                                 style: TextStyle(
//                                     color: Colors.grey, fontSize: 16),
//                                 children: [
//                                   TextSpan(
//                                     text: "Sign Up",
//                                     style: TextStyle(
//                                       color: Colors.teal,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
