import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final String username;
  final String password;

  const LoginRequestModel({
    required this.username,
    required this.password,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'UserName': username,
      'UserPassword': password,
    };
  }

  @override
  List<Object> get props => [username, password];
}


