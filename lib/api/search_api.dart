import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'package:sb_bookshelf/entities/book_detail.dart';
import 'package:sb_bookshelf/entities/search_result.dart';
import 'api_endpoint.dart';
import '../di.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  ApiEndpoint apiEndPoint = di.apiEndpoint;

  Future<SearchResult> initialQuery(String query) async {
    final resource = apiEndPoint.host + '/1.0/search/$query';
    //TODO: urlEncode Query for multiple keywords
    //TODO: retryOnFail, Caching
    final resp = await http.get(resource);
    if (resp.statusCode != 200) {
      throw FormatException('server returned an unepxected message');
    }
    return compute(_parseSearchResult, resp.body);
  }

  Future<SearchResult> nextPageQuery(String query, int page) async {
    final resource = apiEndPoint.host + '/1.0/search/$query/$page';
    //TODO: urlEncode Query for multiple keywords
    final resp = await http.get(resource);
    if (resp.statusCode != 200) {
      throw FormatException('server returned an unepxected message');
    }
    return compute(_parseSearchResult, resp.body);
  }

  Future<BookDetail> detail(String isbn13) async {
    // TODO: assert isbn13 is not null
    final resource = apiEndPoint.host + '/1.0/books/$isbn13';
    final resp = await http.get(resource);
    if (resp.statusCode != 200) {
      throw FormatException('server returned an unepxected message');
    }
    return compute(_parseBookDetail, resp.body);
  }
}

SearchResult _parseSearchResult(String jsonString) {
  final Map<String, dynamic> map = json.decode(jsonString);
  final result = SearchResult.fromMap(map);
  return result;
}

BookDetail _parseBookDetail(String jsonString) {
  final Map<String, dynamic> map = json.decode(jsonString);
  final result = BookDetail.fromMap(map);
  return result;
}
