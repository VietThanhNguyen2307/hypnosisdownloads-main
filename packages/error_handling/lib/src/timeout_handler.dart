const _requestTimeout = Duration(seconds: 30);

extension TimeoutHandler on Future {
  Future timeoutIfTakingTooLong() {
    return timeout(_requestTimeout, onTimeout: () => throw Exception('Timeout'));
  }
}
