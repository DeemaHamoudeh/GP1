import 'dart:convert';

// UserModel class
class UserModel {
  final String? username;
  final String? email;
  final String? identifier;
  String password;
  final String? confirmPassword;
  final String? role;
  final String? plan;
  final String? condition;
  final TemporalPin? temporalPin;

  UserModel({
    this.username,
    this.email,
    this.identifier,
    required this.password,
    this.confirmPassword,
    this.role,
    this.plan,
    this.condition,
    this.temporalPin,
  });

  // Method to update password
  void updatePassword(String newPassword) {
    this.password = newPassword;
  }

  // Convert UserModel to JSON for API requests
  Map<String, dynamic> toJson({bool forSignup = false}) {
    if (forSignup) {
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
      return {
        'identifier': identifier,
        'password': password,
      };
    }
  }

  // Create UserModel from JSON response
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

// Reset Email Request
class ResetEmailRequest {
  String email;

  ResetEmailRequest({required this.email});

  factory ResetEmailRequest.fromJson(Map<String, dynamic> json) =>
      ResetEmailRequest(email: json["email"]);

  Map<String, dynamic> toJson() => {"email": email};
}

// Reset Email Response
class ResetEmailResponse {
  String message;

  ResetEmailResponse({required this.message});

  factory ResetEmailResponse.fromJson(Map<String, dynamic> json) =>
      ResetEmailResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}

// Verify Pin Request
class VerifyPinRequest {
  String email;
  TemporalPin temporalPin;

  VerifyPinRequest({required this.email, required this.temporalPin});

  factory VerifyPinRequest.fromJson(Map<String, dynamic> json) =>
      VerifyPinRequest(
        email: json["email"],
        temporalPin: TemporalPin.fromJson(json["temporalPin"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "temporalPin": temporalPin.toJson(),
      };
}

// TemporalPin class for verification
class TemporalPin {
  String code;

  TemporalPin({required this.code});

  factory TemporalPin.fromJson(Map<String, dynamic> json) =>
      TemporalPin(code: json["code"]);

  Map<String, dynamic> toJson() => {"code": code};
}

// Verify Pin Response
class VerifyPinResponse {
  String message;

  VerifyPinResponse({required this.message});

  factory VerifyPinResponse.fromJson(Map<String, dynamic> json) =>
      VerifyPinResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}

class CreatePasswordRequest {
  String email;
  String newPassword;
  String confirmPassword;

  CreatePasswordRequest({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory CreatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      CreatePasswordRequest(
        email: json["email"],
        newPassword: json["newPassword"],
        confirmPassword: json["confirmPassword"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
}

class CreatePasswordResponse {
  String message;

  CreatePasswordResponse({
    required this.message,
  });

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      CreatePasswordResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
