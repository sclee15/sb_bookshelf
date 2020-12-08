import 'package:sb_bookshelf/api/api_endpoint.dart';

class DI {
  static final DI _singleton = DI._internal();

  factory DI() {
    return _singleton;
  }
  DI._internal();

  ApiEnpoint apiEnpoint;
  putApiEndpoint(ApiEnpoint apiEnpoint) {
    this.apiEnpoint = apiEnpoint;
  }
}

final DI di = DI();
