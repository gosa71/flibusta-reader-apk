import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:utopic_open_file/utopic_open_file.dart';

class FileUtils {
  static Future<Directory> getStorageDir() async {
    final directory = await getExternalStorageDirectory();
    final booksDir = Directory('${directory.path}/FlibustaBooks');
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }
    return booksDir;
  }

  static Future<String> getBooksDirectoryPath() async {
    final dir = await getStorageDir();
    return dir.path;
  }

  static Future<List<FileSystemEntity>> getDownloadedBooks() async {
    final path = await getBooksDirectoryPath();
    final dir = Directory(path);
    if (!await dir.exists()) return [];
    return dir.listSync().where((e) => e.path.endsWith('.fb2') || e.path.endsWith('.zip')).toList();
  }

  static Future<void> openFile(String path) async {
    await OpenFile.open(path);
  }

  static Future<File> saveBookToFile(List<int> bytes, String fileName) async {
    final path = await getBooksDirectoryPath();
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
