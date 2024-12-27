class UserModel {
  final String identifier;
  final String password;

  UserModel({required this.identifier, required this.password});

  // Convert a UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }

  // Convert a JSON object to a UserModel
  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      identifier: json['identifier'],
      password: json['password'],
    );
  }
}

class LoginResponse {
  final String message;
  final String token;
  final UserData user;

  LoginResponse(
      {required this.message, required this.token, required this.user});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }

  static LoginResponse fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final String id;
  final String username;
  final String email;
  final String role;
  final String condition;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'condition': condition,
    };
  }

  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      condition: json['condition'],
    );
  }
}
