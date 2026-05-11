import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

String parseErrorMessageFrom(dynamic exception) {
  final String errorMessage;
  if (exception is DioError) {
    if (exception.error != null) {
      errorMessage = exception.error.toString();
    } else if (exception.response != null) {
      if (exception.response!.data.toString().isNotEmpty) {
        errorMessage = exception.response!.data.toString();
      } else if (exception.response!.statusMessage.toString().isNotEmpty) {
        errorMessage = exception.response!.statusMessage.toString();
      } else {
        errorMessage = exception.error.toString();
      }
    } else {
      errorMessage = exception.message ?? '';
    }
  } else if (exception is PlatformException) {
    errorMessage = exception.message ?? exception.toString();
  } else {
    var value;
    try {
      value = exception.message.toString();
    } catch (_) {
      value = exception.toString();
    }
    errorMessage = value;
  }
  if (errorMessage.contains('Failed host lookup')) {
    return 'No internet connection';
  }
  return errorMessage
      // Remove string between [] from error message
      .replaceAll(RegExp(r'\[.*?\] '), '')
      .replaceAll(RegExp(r'\[.*?\]'), '')
      // Replace "Exception" with "Error"
      .replaceAll('Exception', 'Error');
}
