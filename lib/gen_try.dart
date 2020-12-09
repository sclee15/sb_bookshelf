import 'dart:async';

class GenTry {
  static Future<T> execute<T>(Future<T> Function() cb, [int maxTry = 3]) {
    return _executeImpl<T>(cb, 0, maxTry);
  }

  static Future<T> _executeImpl<T>(
      Future<T> Function() cb, int retry, int maxTry) async {
    try {
      final tried = await cb();
      return tried;
    } catch (e) {
      if (retry < maxTry) {
        //delay function to reduce server load
        await Future.delayed(Duration(milliseconds: 200 * retry));
        return await _executeImpl(cb, retry + 1, maxTry);
      } else {
        rethrow;
      }
    }
  }
}
