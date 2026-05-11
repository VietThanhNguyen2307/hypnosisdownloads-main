import 'dart:convert';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:authentication_logic/src/config.dart';
import 'package:dio/dio.dart';

class RegisterWithEmailPasswordRepository {
  const RegisterWithEmailPasswordRepository(
    this._httpClient,
  );

  final Dio _httpClient;

  Future<CurrentUser> registerWithEmailPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final authFormData = FormData.fromMap(
      {
        "action": Config.registerAction,
        "rev": 1,
        "mail": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
      },
    );

    final response = await _httpClient.post(
      "/${Config.userAccountPath}",
      data: authFormData,
    );

    forceToThrowExceptionIfFailed(response);

    final json = jsonDecode(response.data);
    json['name'] = '$firstName $lastName';
    json['email'] = email;
    json['password'] = password;
    return CurrentUser.fromJson(json);
  }

  void forceToThrowExceptionIfFailed(Response<dynamic> response) {
    final responseErrorCode = jsonDecode(response.data)['error'];
    if (responseErrorCode > 0) {
      throw Exception(
        jsonDecode(response.data)['errorstr'],
      );
    } else if (responseErrorCode < 0) {
      throw Exception(responseErrorCode);
    }
  }
}
