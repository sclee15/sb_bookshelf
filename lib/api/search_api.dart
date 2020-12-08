import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'package:sb_bookshelf/entities/book.dart';
import 'api_endpoint.dart';
import '../di.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  ApiEndpoint apiEndPoint = di.apiEndpoint;

  Future<List<Book>> initialQuery(String query) async {
    final resource = apiEndPoint.host + '/1.0/search/$query';
    final resp = await http.get(resource);
    if (resp.statusCode != 200) {
      throw FormatException('server returned an unepxected message');
    }
    return compute(_parseBooks, resp.body);
  }
}

List<Book> _parseBooks(String jsonString) {
  final Map<String, dynamic> map = json.decode(jsonString);
  final mapBooks = (map['books'] as List).cast<Map<String, dynamic>>();
  final books = mapBooks.map((e) => Book.fromMap(e)).toList();
  return books;
}
