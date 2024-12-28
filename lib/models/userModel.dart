class UserModel {
  final String? username; // Username for signup
  final String? email; // Email for signup or login
  final String? identifier; // Username or email for login
  final String password;
  final String? confirmPassword; // Only for signup
  final String? role; // Only for signup
  final String? plan; // Only for signup
  final String? condition; // Only for signup

  UserModel({
    this.username,
    this.email,
    this.identifier,
    required this.password,
    this.confirmPassword,
    this.role,
    this.plan,
    this.condition,
  });

  // Convert a UserModel to JSON for API requests
  Map<String, dynamic> toJson({bool forSignup = false}) {
    print('toJson called with forSignup: $forSignup');
    if (forSignup) {
      // For signup, include username and email separately
      return {
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
        'plan': plan,
        'condition': condition,
      };
    } else {
      // For login, use identifier (username or email)
      return {
        'identifier': identifier,
        'password': password,
      };
    }
  }

  // Create a UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      identifier: json['identifier'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      role: json['role'],
      plan: json['plan'],
      condition: json['condition'],
    );
  }
}
