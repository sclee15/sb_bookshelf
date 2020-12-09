import 'package:flutter_test/flutter_test.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/di.dart';

void main() {
  test('SearchApi.initialQuery', () async {
    di.putApiEndpoint(ApiEndpoint('https://api.itbook.store'));
    final api = SearchApi();
    final searchResult = await api.initialQuery("mongodb");
    expect(searchResult.books, isNotEmpty);
    expect(searchResult.books.first.title, equals('Practical MongoDB'));
  });
}
