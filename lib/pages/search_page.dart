import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sb_bookshelf/entities/book.dart';
import 'package:sb_bookshelf/pages/detail_book_page.dart';
import 'package:sb_bookshelf/stores/search_store.dart';

import '../cache_image_file.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchStore _searchStore = SearchStore();
  TextEditingController _tecQuery = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchStore.dispose();
    super.dispose();
  }

  Widget _buildBookCard(Book book) {
    return InkWell(
      onTap: () {
        _showBook(book);
      },
      child: Card(
        child: Row(
          children: [
            FutureBuilder<File>(
              future: CachedImageFile.getImageFile(book.image),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.file(snapshot.data);
                } else {
                  return Text('downloading');
                }
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Text(book.title),
                  Text(book.subtitle),
                  Text(book.price),
                  Text(book.isbn13),
                  Text(book.url),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _searchStore.fetchNextPage(_tecQuery.text);
    }
  }

  _showBook(Book book) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DetailBookPage(book: book)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          TextField(
            controller: _tecQuery,
            onSubmitted: (val) {
              _searchStore.search(val);
            },
          ),
          StreamBuilder<SearchState>(
              stream: _searchStore.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.fetching) {
                  return LinearProgressIndicator();
                }
                return SizedBox(height: 0);
              }),
          StreamBuilder<SearchState>(
            stream: _searchStore.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LinearProgressIndicator();
              } else if (snapshot.hasData &&
                  snapshot.data.errorMessage.isNotEmpty) {
                return Text(snapshot.data.errorMessage);
              }

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.hasData
                      ? snapshot.data.searchResult?.books?.length ?? 1
                      : 1,
                  itemBuilder: (context, index) {
                    final _bookCount =
                        snapshot.data.searchResult?.books?.length ?? 0;
                    if (index + 1 == _bookCount) {
                      return Row(children: [
                        Container(
                            width: 60, child: CircularProgressIndicator()),
                        Text('Looking for more books!')
                      ]);
                    } else {
                      return _buildBookCard(
                          snapshot.data.searchResult.books.elementAt(index));
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
