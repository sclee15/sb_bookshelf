import 'package:sb_bookshelf/api/api_endpoint.dart';

class DI {
  static final DI _singleton = DI._internal();

  factory DI() {
    return _singleton;
  }
  DI._internal();

  ApiEndpoint apiEndpoint;
  putApiEndpoint(ApiEndpoint apiEnpoint) {
    this.apiEndpoint = apiEnpoint;
  }
}

final DI di = DI();
