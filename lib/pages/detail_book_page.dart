import 'package:flutter/material.dart';
import 'package:sb_bookshelf/gen_try.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sb_bookshelf/api/search_api.dart';
import 'package:sb_bookshelf/cache_map.dart';
import 'package:sb_bookshelf/entities/book.dart';
import 'package:sb_bookshelf/entities/book_detail.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;
  DetailBookPage({Key key, @required this.book}) : super(key: key);

  @override
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final _searchApi = SearchApi();
  final _defaultHeaderStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final _tecMemo = TextEditingController();

  BookDetail _bookDetail; //nullable

  @override
  void initState() {
    super.initState();
    _afterInit();
  }

  _afterInit() async {
    _bookDetail = await GenTry.execute<BookDetail>(
        () => _searchApi.detail(widget.book.isbn13));
    final note = await CacheMapIsolate().get("__NOTE__:${widget.book.isbn13}");
    if (note != null) {
      _tecMemo.text = note;
    }
    setState(() {});
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildProperty(String name, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(width: 150, child: Text(name)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPropertyUrl(String name, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _launchInBrowser(value);
        },
        child: Row(
          children: [
            Container(width: 150, child: Text(name)),
            Expanded(child: Text(value, style: TextStyle(color: Colors.blue))),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_bookDetail == null) return LinearProgressIndicator();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General', style: _defaultHeaderStyle),
        Card(
          child: Column(
            children: [
              _buildProperty('title', _bookDetail.title),
              _buildProperty('subtitle', _bookDetail.title),
              _buildProperty('authors', _bookDetail.authors),
              _buildProperty('publisher', _bookDetail.publisher),
              _buildProperty('isbn10', _bookDetail.isbn10),
              _buildProperty('isbn13', _bookDetail.isbn13),
              _buildProperty('pages', _bookDetail.pages),
              _buildProperty('year', _bookDetail.year),
              _buildProperty('rating', _bookDetail.rating),
              _buildProperty('desc', _bookDetail.desc),
              _buildProperty('price', _bookDetail.price),
              _buildProperty('image', _bookDetail.image),
              _buildPropertyUrl('url', _bookDetail.url),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text('PDF', style: _defaultHeaderStyle),
        Card(
          child: Column(
            children: [
              if (_bookDetail.pdfs.length == 0) Text('no pdf'),
              ...(_bookDetail.pdfs.map((e) => _buildPropertyUrl(e.key, e.url))),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text('Note', style: _defaultHeaderStyle),
        Card(
          child: Container(
            width: double.infinity,
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: _tecMemo,
                  maxLines: 5,
                ),
                MaterialButton(
                  child: Text('Save'),
                  onPressed: () {
                    CacheMapIsolate()
                        .put("__NOTE__:${widget.book.isbn13}", _tecMemo.text);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Book')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(),
      )),
    );
  }
}
