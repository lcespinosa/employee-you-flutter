import 'package:starterkit/models/user.dart';

class LoginResponse {
  User user;
  String access_token;
  String token_type;
  DateTime expires_at;

  LoginResponse({
    this.user,
    this.access_token,
    this.token_type,
    this.expires_at,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    access_token = json['access_token'];
    token_type = json['token_type'];
    expires_at = DateTime.parse(json['expires_at']);
  }
}