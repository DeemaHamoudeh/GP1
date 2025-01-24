import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:frontend/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'storeEmployeeconfirm_page.dart';

class SignUpStoreStoreEmployeeColorBlindNormalPage extends StatefulWidget {
  const SignUpStoreStoreEmployeeColorBlindNormalPage({
    super.key,
  });

  @override
  State<SignUpStoreStoreEmployeeColorBlindNormalPage> createState() => _SignUpStoreStoreEmployeePageState();
}

class _SignUpStoreStoreEmployeePageState
    extends State<SignUpStoreStoreEmployeeColorBlindNormalPage> {
    final TextEditingController _coverLetterController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> _jobPositions = [
    'Inventory Manager',
    'Customer Service',
    'Stock Associate',
    'Sales Assistant',
    'Shift Supervisor',
  ];

  String? _selectedJobPosition;

  String? colorBlindType;

  @override
  void initState() {
    super.initState();
    _loadColorBlindNormalType();
  }

  // Load the saved color-blind type from SharedPreferences
  Future<void> _loadColorBlindNormalType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colorBlindType = prefs.getString('colorblind_type') ?? 'none';
    });
  }

  // Map the colorBlindType string to a ColorFilter
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
    void _showConfirmationMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text(
          "Your information has been submitted successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close the confirmation message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeConfirmWait()),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    final colorFilter = _getColorFilter(colorBlindType);

    return MaterialApp(
      home: Scaffold(
        body: ColorFiltered(
          colorFilter: colorFilter,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logPages/wall3.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Back Button
              Positioned(
                top: 40,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              // Sign-Up Form
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Title
                        Text(
                          "Create new account",
                          style: const TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign up as Store StoreEmployee (${colorBlindType ?? 'Normal Vision'}))",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Form Fields
                        _buildTextField(
                          labelText: "First Name",
                          icon: Icons.person,
                          validator: (value) => value!.isEmpty
                              ? "Please enter your first name"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Last Name",
                          icon: Icons.person_outline,
                          validator: (value) =>
                              value!.isEmpty ? "Please enter your last name" : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Email",
                          icon: Icons.email_outlined,
                          validator: (value) =>
                              value!.isEmpty ? "Please enter your Email" : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) => value!.length < 8
                              ? "Password must be at least 8 characters"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Confirm Password",
                          icon: Icons.lock,
                          isPassword: true,
                          validator: (value) => value!.isEmpty
                              ? "Please confirm your password"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Store ID you what to apply for",
                          icon: Icons.lock,
                          validator: (value) => value!.length < 5
                              ? "please enter Store ID (it should be 5 numbers)"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Job Position",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          items: _jobPositions.map((String position) {
                            return DropdownMenuItem<String>(
                              value: position,
                              child: Text(position),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedJobPosition = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a job position" : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          labelText: "Phone Number",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) => value!.isEmpty
                              ? "Please enter your phone number"
                              : null,
                        ),
                        const SizedBox(height: 20),
                          const Text(
                            "Cover Letter",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _coverLetterController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Write your cover letter here...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Please write a cover letter"
                                : null,
                          ),
                        const SizedBox(height: 40),
                        Center(
                              child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                            _showConfirmationMessage();
                            }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent,
                            ).copyWith(
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    AppColors.basicBackgroundColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(100, 60, 172, 161),
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                constraints:
                                    BoxConstraints(minWidth: 88, minHeight: 44),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text("Submit"),
                                  ],
                                ),
                              ),
                            ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        prefixIcon: Icon(icon, size: 24),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
