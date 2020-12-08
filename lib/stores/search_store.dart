import 'dart:async';
import 'package:meta/meta.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/entities/book.dart';

class SearchState {
  final List<Book> books;
  final bool fetching;
  final int page;

  factory SearchState.initState() =>
      SearchState(page: 0, books: [], fetching: false);
  SearchState(
      {@required this.books, @required this.page, @required this.fetching});
  SearchState copyFrom({List<Book> books, int page, bool fetching}) {
    return SearchState(
        books: books ?? this.books,
        page: page ?? this.page,
        fetching: fetching ?? this.fetching);
  }
}

class SearchStore {
  final _streamController = StreamController<SearchState>.broadcast();
  Stream<SearchState> get stream => _streamController.stream;
  final _searchApi = SearchApi();

  SearchState state = SearchState.initState();

  search(String query) async {
    _updateState(state.copyFrom(fetching: true));
    try {
      final books = await _searchApi.initialQuery(query);
      _updateState(state.copyFrom(books: books));
    } finally {
      _updateState(state.copyFrom(fetching: false));
    }
  }

  _updateState(SearchState newState) {
    state = newState;
    _streamController.sink.add(state);
  }

  void dispose() {
    _streamController.close();
  }
}
