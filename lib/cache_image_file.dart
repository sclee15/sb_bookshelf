import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CachedImageFile {
  static Future<File> getImageFile(String url) async {
    final completer = Completer<File>();
    () async {
      final directory = await getTemporaryDirectory();
      // TODO: filename should be shorted by a hash function
      final filename =
          '${directory.path}/${url.replaceAll('/', '__').replaceAll(':', '')}';
      final file = File(filename);
      final exist = await file.exists();
      if (exist) {
        completer.complete(file);
      } else {
        completer.complete(_downloadFile(url, filename));
      }
    }();
    return completer.future;
  }

  static Future<File> _downloadFile(String url, String filename) async {
    final _client = http.Client();
    var res = await _client.get(Uri.parse(url));
    var bytes = res.bodyBytes;
    File file = File(filename);
    await file.writeAsBytes(bytes);
    return file;
  }
}
