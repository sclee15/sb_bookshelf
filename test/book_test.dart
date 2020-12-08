import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_bookshelf/entities/book.dart';

void main() {
  final aBookString = """{
            "title": "Practical MongoDB",
            "subtitle": "Architecting, Developing, and Administering MongoDB",
            "isbn13": "9781484206485",
            "price": "\$32.04",
            "image": "https://itbook.store/img/books/9781484206485.png",
            "url": "https://itbook.store/books/9781484206485"
        }""";

  test('book.fromMap', () async {
    final Map<String, dynamic> map = json.decode(aBookString);
    final aBook = Book.fromMap(map);
    expect(aBook.title, "Practical MongoDB");
    expect(
        aBook.subtitle, "Architecting, Developing, and Administering MongoDB");
    expect(aBook.isbn13, "9781484206485");
    expect(aBook.price, "\$32.04");
    expect(aBook.image, "https://itbook.store/img/books/9781484206485.png");
    expect(aBook.url, "https://itbook.store/books/9781484206485");
  });

  test('book == book', () async {
    final Map<String, dynamic> map = json.decode(aBookString);
    final aBook = Book.fromMap(map);
    final bBook = Book.fromMap(map);
    expect(aBook, equals(bBook));
  });

  test('book != book', () async {
    final Map<String, dynamic> map = json.decode(aBookString);
    final aBook = Book.fromMap(map);
    //Book name changed
    map[BookFieldNames.title] += " (2nd Edition)";
    final bBook = Book.fromMap(map);
    //Since aBook.title != bBook title, aBook != bBook
    expect(aBook, isNot(equals(bBook)));
  });
}
