import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flibusta/model/fb2/fb2_book.dart';

class Fb2Parser {
  static Future<Fb2Book> parseFromFile(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return parseFromBytes(bytes, filePath);
  }

  static Future<Fb2Book> parseFromBytes(List<int> bytes, [String sourcePath]) async {
    // Handle zip (fb2.zip)
    if (bytes.length > 4 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        if (file.name.toLowerCase().endsWith('.fb2')) {
          bytes = file.content as List<int>;
          break;
        }
      }
    }

    String content;
    try {
      content = utf8.decode(bytes);
    } catch (_) {
      content = latin1.decode(bytes);
    }

    final document = xml.XmlDocument.parse(content);
    final book = Fb2Book();
    book.sourcePath = sourcePath;

    // Title
    final titleInfo = document.findAllElements('title-info').first;
    final bookTitle = titleInfo.findElements('book-title').first;
    book.title = bookTitle.text.trim();

    // Authors
    final authors = <String>[];
    for (final a in titleInfo.findElements('author')) {
      final first = a.findElements('first-name').map((e) => e.text).join(' ');
      final middle = a.findElements('middle-name').map((e) => e.text).join(' ');
      final last = a.findElements('last-name').map((e) => e.text).join(' ');
      authors.add([last, first, middle].where((s) => s.isNotEmpty).join(' ').trim());
    }
    book.authors = authors;

    // Body / sections
    final bodies = document.findAllElements('body');
    final chapters = <Fb2Chapter>[];
    for (final body in bodies) {
      for (final section in body.findElements('section')) {
        final chapter = _parseSection(section);
        if (chapter != null) chapters.add(chapter);
      }
    }
    book.chapters = chapters;

    // Description / annotation
    final annotation = titleInfo.findElements('annotation');
    if (annotation.isNotEmpty) {
      book.annotation = _extractText(annotation.first);
    }

    return book;
  }

  static Fb2Chapter _parseSection(xml.XmlElement section) {
    final titleEls = section.findElements('title');
    String title = '';
    if (titleEls.isNotEmpty) {
      title = _extractText(titleEls.first) ?? '';
    }
    final blocks = <Fb2Block>[];
    for (final child in section.children) {
      if (child is xml.XmlElement) {
        if (child.name.local == 'p') {
          blocks.add(Fb2Block(type: 'p', text: _extractText(child) ?? ''));
        } else if (child.name.local == 'subtitle') {
          blocks.add(Fb2Block(type: 'subtitle', text: _extractText(child) ?? ''));
        } else if (child.name.local == 'empty-line') {
          blocks.add(Fb2Block(type: 'empty-line', text: ''));
        } else if (child.name.local == 'section') {
          // nested handled by recursion if needed
        }
      }
    }
    if (title.isEmpty && blocks.isEmpty) return null;
    return Fb2Chapter(title: title, blocks: blocks);
  }

  static String _extractText(xml.XmlNode node) {
    final parts = <String>[];
    node.descendants.whereType<xml.XmlText>().forEach((text) {
      final t = text.text.trim();
      if (t.isNotEmpty) parts.add(t);
    });
    return parts.isEmpty ? null : parts.join(' ');
  }
}
