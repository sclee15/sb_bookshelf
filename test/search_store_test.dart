import 'package:flutter_test/flutter_test.dart';
import 'package:sb_bookshelf/api/api_endpoint.dart';
import 'package:sb_bookshelf/di.dart';
import 'package:sb_bookshelf/stores/search_store.dart';

void main() {
  test('SearchApi.initialQuery', () async {
    di.putApiEndpoint(ApiEndpoint('https://api.itbook.store'));
    final store = SearchStore();
    await store.search("mongodb");
    expect(store.state.searchResult.books, isNotEmpty);
    expect(store.state.searchResult.books.first.title,
        equals('Practical MongoDB'));
  });
}
