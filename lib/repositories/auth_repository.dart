import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:starterkit/api/api_base_helper.dart';
import 'package:starterkit/api/error.dart';
import 'package:starterkit/models/user.dart';
import 'package:starterkit/responses/login_response.dart';
import 'package:starterkit/utils/constants.dart';

class AuthRepository extends ValueNotifier<User> {
  ApiBaseHelper _helper;

  AuthRepository(this._helper) : super(null) {
    _helper.onError.listen((error) {
      if (error is UnauthorizedError) {
        value = null;
      }
    });
  }

  User get currentUser => value;

  Future<LoginResponse> signInWithPin(String pin) async {
    try {
      final response = await _helper.post(
          Constants.apiBaseUrl + '/security/pin',
          body: jsonEncode(<String, String>{
            'pin': pin,
          }));
      print(response);
      final responseJson = json.decode(response.body.toString());
      final loginResponse = LoginResponse.fromJson(responseJson);
      value = loginResponse.user;
      _helper.saveUserToken(loginResponse.token_type + ' ' + loginResponse.access_token);
      return loginResponse;
    } catch (e) {
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _helper.get(
          Constants.apiBaseUrl + '/security/user');
      print(response);
      final responseJson = json.decode(response.body.toString());
      User user = User.fromJson(responseJson.data);
      value = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final response = await _helper.get(
          Constants.apiBaseUrl + '/security/logout');
      print(response);
    } catch (e) {
    }
    value = null;
    return null;
  }
}