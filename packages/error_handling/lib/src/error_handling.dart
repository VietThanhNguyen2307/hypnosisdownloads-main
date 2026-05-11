class DioServerException implements Exception {
  final int? errorCode;
  final String? errorMessage;

  DioServerException({required this.errorCode, this.errorMessage});

  @override
  String toString() {
    if (errorCode == null) return super.toString();

    if (errorCode! > 0) {
      return 'Error: $errorMessage';
    } else {
      return 'Unknown error';
    }
  }
}
