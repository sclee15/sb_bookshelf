import 'package:flutter/material.dart';
import 'package:sb_bookshelf/entities/book.dart';
import 'package:sb_bookshelf/stores/search_store.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchStore searchStore = SearchStore();
  TextEditingController tecQuery = TextEditingController();

  Widget buildBookCard(Book book) {
    return Card(
      child: Row(
        children: [
          Image.network(book.image), //TODO: Image Cache
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          TextField(
            controller: tecQuery,
            onSubmitted: (val) => searchStore.search(val),
          ),
          StreamBuilder<SearchState>(
              stream: searchStore.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.fetching) {
                  return LinearProgressIndicator();
                }
                return SizedBox(height: 0);
              }),
          StreamBuilder<SearchState>(
            stream: searchStore.stream,
            builder: (context, snapshot) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.hasData ? snapshot.data.books.length : 0,
                  itemBuilder: (context, index) {
                    return buildBookCard(snapshot.data.books.elementAt(index));
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
