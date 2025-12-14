import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class LoginResponseModel extends Equatable {
  final bool success;
  final String message;
  final String? token;
  final String? refreshToken;
  final UserDataModel? user;

  const LoginResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.refreshToken,
    this.user,
  });

  // Factory constructor to create from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? UserDataModel.fromJson(json['user']) : null,
    );
  }

  // Convert to Entity (optional, if you need to convert to domain entity)
  UserEntity? toEntity() {
    if (user != null) {
      return UserEntity(
        username: user!.username,
        password: '', // Never store password in entity
      );
    }
    return null;
  }

  @override
  List<Object?> get props => [success, message, token, refreshToken, user];
}

class UserDataModel extends Equatable {
  final String username;
  final String userId;
  final String? email;
  final String? role;
  final String? name;

  const UserDataModel({
    required this.username,
    required this.userId,
    this.email,
    this.role,
    this.name,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      username: json['username'] ?? '',
      userId: json['userId'] ?? json['id'] ?? '',
      email: json['email'],
      role: json['role'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userId': userId,
      'email': email,
      'role': role,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [username, userId, email, role, name];
}


