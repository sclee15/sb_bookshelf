import 'dart:async';

class GenTry {
  static Future<T> execute<T>(Future<T> Function() cb, [int maxTry = 3]) {
    return _executeImpl<T>(cb, 0, maxTry);
  }

  static Future<T> _executeImpl<T>(
      Future<T> Function() cb, int retry, int maxTry) async {
    try {
      //TODO delay function to reduce server load
      final tried = await cb();
      return tried;
    } catch (e) {
      if (retry < maxTry) {
        return await _executeImpl(cb, retry + 1, maxTry);
      } else {
        rethrow;
      }
    }
  }
}
