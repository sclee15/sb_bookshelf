import 'package:flutter/material.dart';
import 'package:sb_bookshelf/pages/search_page.dart';

class BookShelfApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookshelfApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(), // placeholder for now
    );
  }
}
