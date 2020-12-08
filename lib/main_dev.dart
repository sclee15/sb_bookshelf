import 'package:flutter/material.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'di.dart';
import 'main_common.dart';

void main() {
  //Inject ApiEnpoint for dev enviornment
  di.putApiEndpoint(ApiEndpoint('https://localhost'));
  runApp(BookShelfApp());
}
