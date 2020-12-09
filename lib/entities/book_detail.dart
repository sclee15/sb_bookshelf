import 'package:meta/meta.dart'; //Flutter's default meta package

class BookPDF {
  final String key;
  final String url;

  BookPDF(this.key, this.url);
}

class BookDetail {
  final String error;
  final String title;
  final String subtitle;
  final String authors;
  final String publisher;
  final String language;
  final String isbn10;
  final String isbn13;
  final String pages;
  final String year;
  final String rating;
  final String desc;
  final String price;
  final String image;
  final String url;
  final List<BookPDF> pdfs;

  BookDetail(
      {@required this.error,
      @required this.title,
      @required this.subtitle,
      @required this.authors,
      @required this.publisher,
      @required this.language,
      @required this.isbn10,
      @required this.isbn13,
      @required this.pages,
      @required this.year,
      @required this.rating,
      @required this.desc,
      @required this.price,
      @required this.image,
      @required this.url,
      @required this.pdfs});

  factory BookDetail.fromMap(Map<String, dynamic> json) {
    final pdfs = <BookPDF>[];
    ((json['pdf'] ?? <String, dynamic>{}) as Map<String, dynamic>)
        .forEach((key, value) {
      pdfs.add(BookPDF(key, value));
    });

    return BookDetail(
        error: json['error'],
        title: json['title'],
        subtitle: json['subtitle'],
        authors: json['authors'],
        publisher: json['publisher'],
        language: json['language'],
        isbn10: json['isbn10'],
        isbn13: json['isbn13'],
        pages: json['pages'],
        year: json['year'],
        rating: json['rating'],
        desc: json['desc'],
        price: json['price'],
        image: json['image'],
        url: json['url'],
        pdfs: pdfs);
  }
}
