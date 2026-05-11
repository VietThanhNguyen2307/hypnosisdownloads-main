import 'dart:async';
import 'dart:convert';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:authentication_logic/src/config.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithEmailPasswordRepository {
  const LoginWithEmailPasswordRepository(this._httpClient);

  final Dio _httpClient;

  Future<CurrentUser> loginWithEmailPassword(
    String email,
    String password,
    bool remember,
  ) async {
    final authFormData = FormData.fromMap(
      {
        "action": Config.userAccountAction,
        "rev": 2,
        "name": email,
        "password": password,
      },
    );

    final response = await _httpClient.post(
      "/${Config.userAccountPath}",
      data: authFormData,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', remember ? email : '');

    print(remember);

    forceToThrowExceptionIfFailed(response);

    final json = jsonDecode(response.data);
    json['name'] = json['first_name'] + ' ' + json['last_name'];
    json['email'] = email;
    json['password'] = password;
    json['growthzone'] = json['growthzone'] == 'yes';
    return CurrentUser.fromJson(json);
  }

  void forceToThrowExceptionIfFailed(Response<dynamic> response) {
    final responseErrorCode = jsonDecode(response.data)['error'];
    if (responseErrorCode > 0) {
      throw Exception(jsonDecode(response.data)['errorstr']);
    } else if (responseErrorCode < 0) {
      throw Exception(responseErrorCode);
    }
  }
}
