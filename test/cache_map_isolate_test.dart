import 'package:flutter_test/flutter_test.dart';
import 'package:sb_bookshelf/cache_map.dart';

void main() {
  test('CacheIsolate', () async {
    final iso = CacheMapIsolate();
    await iso.put('key', 'val');
    expect(await iso.get('key'), equals('val'));
    await iso.put('key', 'test');
    expect(await iso.get('key'), equals('test'));
    iso.dispose();
  });
}
