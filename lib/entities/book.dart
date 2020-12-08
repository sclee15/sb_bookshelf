import 'package:meta/meta.dart'; //Flutter's default meta package

class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  Book(
      {@required this.title,
      @required this.subtitle,
      @required this.isbn13,
      @required this.price,
      @required this.image,
      @required this.url});

  factory Book.fromMap(Map<String, dynamic> json) {
    // test at test/book_test.dart
    return Book(
        title: json[BookFieldNames.title] as String,
        subtitle: json[BookFieldNames.subtitle] as String,
        isbn13: json[BookFieldNames.isbn13] as String,
        price: json[BookFieldNames.price] as String,
        image: json[BookFieldNames.image] as String,
        url: json[BookFieldNames.url] as String);
  }

  // Normally I would like to use Freezed, but for the no 3rd party requrement, I will do it manually
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          isbn13 == other.isbn13 &&
          price == other.price &&
          image == other.image &&
          url == other.url;

  @override
  int get hashCode => runtimeType.hashCode;
}

class BookFieldNames {
  //For a static check for our future maintainability
  static final String title = 'title';
  static final String subtitle = 'subtitle';
  static final String isbn13 = 'isbn13';
  static final String price = 'price';
  static final String image = 'image';
  static final String url = 'url';
}
