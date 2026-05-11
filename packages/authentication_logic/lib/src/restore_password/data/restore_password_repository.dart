import 'dart:convert';

import 'package:authentication_logic/src/config.dart';
import 'package:dio/dio.dart';

class RestorePasswordRepository {
  const RestorePasswordRepository(this._httpClient);

  final Dio _httpClient;

  Future<void> restorePasswordVia(String email) async {
    // POST with action=resetpasswordjson and name=$email
    final data = FormData.fromMap(
      {
        "action": Config.resetPasswordAction,
        "rev": 1,
        "name": email,
      },
    );
    final response = await _httpClient.post(
      "/${Config.userAccountPath}",
      data: data,
    );
    forceToThrowExceptionIfFailed(response);
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
