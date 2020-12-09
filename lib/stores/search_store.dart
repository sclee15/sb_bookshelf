import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/entities/book.dart';
import 'package:sb_bookshelf/gen_try.dart';

class SearchState {
  final List<Book> books;
  final bool fetching;
  final int page;
  final String errorMessage;

  factory SearchState.initState() =>
      SearchState(page: 0, books: [], fetching: false, errorMessage: '');
  SearchState(
      {@required this.books,
      @required this.page,
      @required this.fetching,
      @required this.errorMessage});
  SearchState copyFrom(
      {List<Book> books, int page, bool fetching, String errorMessage}) {
    return SearchState(
        books: books ?? this.books,
        page: page ?? this.page,
        fetching: fetching ?? this.fetching,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class SearchStore {
  static const String errorKey = 'SS'; //Stands for SearchStore
  final _streamController = StreamController<SearchState>.broadcast();
  Stream<SearchState> get stream => _streamController.stream;
  final _searchApi = SearchApi();

  SearchState state = SearchState.initState();

  search(String query) async {
    _updateState(state.copyFrom(errorMessage: '', fetching: true));
    try {
      final books = await GenTry.execute<List<Book>>(
          () => _searchApi.initialQuery(query));
      _updateState(state.copyFrom(books: books));
    } on OSError {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot find the server (errNo: ${errorKey}000)',
          books: <Book>[],
          fetching: false));
    } on SocketException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot reach to the server (errNo: ${errorKey}001)',
          books: <Book>[],
          fetching: false));
    } on HttpException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot fetch from the server (errNo: ${errorKey}002)',
          books: <Book>[],
          fetching: false));
    } on FormatException {
      _updateState(state.copyFrom(
          errorMessage:
              'Server returned an unepxected message (errNo: ${errorKey}003)',
          books: <Book>[],
          fetching: false));
    } catch (e) {
      _updateState(state.copyFrom(
          errorMessage: 'Unknown error occured (errNo: ${errorKey}004)',
          books: <Book>[],
          fetching: false));
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
