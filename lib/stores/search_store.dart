import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/cache_map.dart';
import 'package:sb_bookshelf/entities/search_result.dart';
import 'package:sb_bookshelf/gen_try.dart';

class SearchState {
  final SearchResult searchResult; // Nulable
  final bool fetching;
  final String errorMessage;

  factory SearchState.initState() =>
      SearchState(fetching: false, errorMessage: '', searchResult: null);
  SearchState(
      {@required this.searchResult,
      @required this.fetching,
      @required this.errorMessage});
  SearchState copyFrom(
      {bool fetching, String errorMessage, SearchResult searchResult}) {
    return SearchState(
        fetching: fetching ?? this.fetching,
        errorMessage: errorMessage ?? this.errorMessage,
        searchResult: searchResult ?? this.searchResult);
  }
}

class SearchStore {
  static const String _errorKey = 'SS'; //Stands for SearchStore
  final _streamController = StreamController<SearchState>.broadcast();
  Stream<SearchState> get stream => _streamController.stream;
  final _searchApi = SearchApi();

  SearchState state = SearchState.initState();

  SearchStore() {
    () async {
      _streamController.add(state);
    }();
  }

  search(String query) async {
    _updateState(state.copyFrom(errorMessage: '', fetching: true));
    try {
      final cached = await CacheMapIsolate().get('__query:$query');
      if (cached == null) {
        final searchResult = await GenTry.execute<SearchResult>(
            () => _searchApi.initialQuery(query));
        _updateState(state.copyFrom(searchResult: searchResult));
        CacheMapIsolate().put('__query:$query', searchResult.toMap());
      } else {
        _updateState(
            state.copyFrom(searchResult: SearchResult.fromMap(cached)));
      }
    } on OSError {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot find the server (errNo: ${_errorKey}000)',
          searchResult: null,
          fetching: false));
    } on SocketException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot reach to the server (errNo: ${_errorKey}001)',
          searchResult: null,
          fetching: false));
    } on HttpException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot fetch from the server (errNo: ${_errorKey}002)',
          searchResult: null,
          fetching: false));
    } on FormatException {
      _updateState(state.copyFrom(
          errorMessage:
              'Server returned an unepxected message (errNo: ${_errorKey}003)',
          searchResult: null,
          fetching: false));
    } catch (_) {
      _updateState(state.copyFrom(
          errorMessage: 'Unknown error occured (errNo: ${_errorKey}004)',
          searchResult: null,
          fetching: false));
    } finally {
      _updateState(state.copyFrom(fetching: false));
    }
  }

  fetchNextPage(String query) async {
    if (state.fetching) return;
    if (state.searchResult == null) return;
    // to avoid concurrency issue and ready for null safety
    final _searchResult = state.searchResult;
    if (_searchResult.books.length >= int.parse(_searchResult.total)) {
      return;
    }

    _updateState(state.copyFrom(errorMessage: '', fetching: true));
    try {
      final searchResult = await GenTry.execute<SearchResult>(() =>
          _searchApi.nextPageQuery(query, int.parse(_searchResult.page) + 1));
      final newSearchResult = _searchResult.copyFrom(
          error: searchResult.error,
          page: searchResult.page,
          total: searchResult.total,
          books: _searchResult.books..addAll(searchResult.books));
      CacheMapIsolate().put('__query:$query', newSearchResult.toMap());
      _updateState(state.copyFrom(searchResult: newSearchResult));
    } on OSError {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot find the server (errNo: ${_errorKey}000)',
          searchResult: null,
          fetching: false));
    } on SocketException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot reach to the server (errNo: ${_errorKey}001)',
          searchResult: null,
          fetching: false));
    } on HttpException {
      _updateState(state.copyFrom(
          errorMessage: 'Cannot fetch from the server (errNo: ${_errorKey}002)',
          searchResult: null,
          fetching: false));
    } on FormatException {
      _updateState(state.copyFrom(
          errorMessage:
              'Server returned an unepxected message (errNo: ${_errorKey}003)',
          searchResult: null,
          fetching: false));
    } catch (_) {
      _updateState(state.copyFrom(
          errorMessage: 'Unknown error occured (errNo: ${_errorKey}004)',
          searchResult: null,
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
