import 'dart:convert' show base64, utf8;
import 'dart:io';

import 'package:flibusta/constants.dart';
import 'package:flibusta/model/bookCard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utopic_open_file/utopic_open_file.dart';

class FileUtils {
  static Future<String> getBooksDirectoryPath() async {
    final directory = await getExternalStorageDirectory();
    final booksDir = Directory('${directory.path}/FlibustaBooks');
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }
    return booksDir.path;
  }

  static Future<List<FileSystemEntity>> getDownloadedBooks() async {
    final path = await getBooksDirectoryPath();
    final dir = Directory(path);
    if (!await dir.exists()) {
      return [];
    }
    return dir.listSync().where((e) => e.path.endsWith('.fb2') || e.path.endsWith('.zip')).toList();
  }

  static Future<void> openFile(String path) async {
    await OpenFile.open(path);
  }

  static String getFileNameFromBookCard(BookCard bookCard, String format) {
    var name = bookCard.title ?? 'book';
    name = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    if (name.length > 100) {
      name = name.substring(0, 100);
    }
    return '$name.$format';
  }

  static Future<File> saveBookToFile(List<int> bytes, String fileName) async {
    final path = await getBooksDirectoryPath();
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
