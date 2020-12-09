import 'dart:async';
import 'dart:isolate';

enum KeyNames { id, action, key, payload }

class CacheMap {
  final _cache = <String, dynamic>{};

  void put(String key, dynamic payload) {
    _cache[key] = payload;
  }

  dynamic get(String key) {
    return _cache[key];
  }
}

class CacheMapIsolate {
  final _receivePort = new ReceivePort();
  StreamController _broadcastController = StreamController.broadcast();
  Stream<dynamic> get _receiveStream => _broadcastController.stream;
  SendPort _sendPort;
  int _idCounter = 0;

  final _initializeLock = Completer<Null>();

  static final CacheMapIsolate _singleton = CacheMapIsolate._internal();

  factory CacheMapIsolate() {
    return _singleton;
  }

  CacheMapIsolate._internal() {
    afterInit();
  }

  afterInit() async {
    _receivePort.listen((message) {
      if (_sendPort == null) {
        _sendPort = message;
        _initializeLock.complete(null);
      } else {
        _broadcastController.add(message);
      }
    });
    Isolate.spawn(cacheIsolateImpl, _receivePort.sendPort);
    print("afterinit");
  }

  dispose() {
    //TODO: freeup
    _broadcastController.close();
    _receivePort.close();
  }

  put(String key, dynamic data) async {
    await _initializeLock.future;
    _sendPort.send([_idCounter++, 'put', key, data]);
    // fire and forget
  }

  Future<dynamic> get(String key) async {
    await _initializeLock.future;
    final id = _idCounter++;
    _sendPort.send([id, 'get', key]);
    final reply = await _receiveStream
        .firstWhere((element) => element[0] == id)
        .timeout(Duration(milliseconds: 5000));
    return reply[1];
  }
}

cacheIsolateImpl(SendPort sendPort) async {
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  final cacheMap = CacheMap();

  await for (var msg in receivePort) {
    if (msg[KeyNames.action.index] == 'put') {
      cacheMap.put(msg[KeyNames.key.index], msg[KeyNames.payload.index]);
    } else if (msg[KeyNames.action.index] == 'get') {
      final result = cacheMap.get(msg[KeyNames.key.index]);
      sendPort.send([msg[KeyNames.id.index], result]);
    }
  }
}
