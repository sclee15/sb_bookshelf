import 'package:meta/meta.dart';
import 'package:sb_bookshelf/entities/book.dart'; //Flutter's default meta package

class SearchResult {
  final String error;
  final String total;
  final String page;
  final List<Book> books;

  SearchResult(
      {@required this.error,
      @required this.total,
      @required this.page,
      @required this.books});

  factory SearchResult.fromMap(Map<String, dynamic> json) {
    return SearchResult(
      error: json['error'] as String,
      total: json['total'] as String,
      page: json['page'] as String,
      books: (json['books'] as List)
          .cast<Map<String, dynamic>>()
          .map((e) => Book.fromMap(e))
          .toList(),
    );
  }

  SearchResult copyFrom(
      {final String error,
      final String total,
      final String page,
      final List<Book> books}) {
    return SearchResult(
      error: error ?? this.error,
      total: total ?? this.total,
      page: page ?? this.page,
      books: books ?? this.books,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "error": error,
      "total": total,
      "page": page,
      "books": books.map((e) => e.toMap()).toList()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          total == other.total &&
          page == other.page &&
          books == other.books;

  @override
  int get hashCode => runtimeType.hashCode;
}
