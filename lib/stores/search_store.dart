import 'dart:async';
import 'package:meta/meta.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/entities/book.dart';

class SearchState {
  final List<Book> books;
  SearchState({@required this.books});
}

class SearchStore {
  final _streamController = StreamController<SearchState>();
  Stream<SearchState> get stream => _streamController.stream;
  final _searchApi = SearchApi();

  SearchState state = SearchState(books: []);

  search(String query) async {
    final books = await _searchApi.initialQuery(query);
    updateState(SearchState(books: books));
  }

  updateState(SearchState newState) {
    state = newState;
    _streamController.sink.add(state);
  }

  void dispose() {
    _streamController.close();
  }
}
