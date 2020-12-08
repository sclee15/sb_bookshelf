import 'package:flutter_test/flutter_test.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/di.dart';

void main() {
  test('SearchApi.initialQuery', () async {
    di.putApiEndpoint(ApiEndpoint('https://api.itbook.store'));
    final api = SearchApi();
    final books = await api.initialQuery("mongodb");
    expect(books, isNotEmpty);
    expect(books.first.title, equals('Practical MongoDB'));
  });
}
