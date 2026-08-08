import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flutter/material.dart';

/// Simplified typography settings for the reader.
class ReaderTypography {
  final double fontSize;
  final String fontFamily;
  final double lineHeight;
  final TextAlign textAlign;

  const ReaderTypography({
    @required this.fontSize,
    this.fontFamily = 'Inter',
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.justify,
  });

  @override
  bool operator ==(Object other) =>
      other is ReaderTypography &&
      other.fontSize == fontSize &&
      other.fontFamily == fontFamily &&
      other.lineHeight == lineHeight &&
      other.textAlign == textAlign;

  @override
  int get hashCode =>
      fontSize.hashCode ^ fontFamily.hashCode ^ lineHeight.hashCode ^ textAlign.hashCode;
}

/// One physical page of the reader.
class ReaderPage {
  final int chapterIndex;
  final int startBlockIndex;
  final List<Fb2Block> blocks;
  final List<InlineSpan> spans;

  ReaderPage({
    this.chapterIndex,
    this.startBlockIndex,
    this.blocks,
    this.spans,
  });
}

/// Lightweight paginator compatible with the simplified Fb2 model.
class ReaderPaginator {
  static Future<List<ReaderPage>> paginate({
    Fb2Book book,
    List<Fb2Chapter> chapters,
    Size size,
    double width,
    double height,
    @required ReaderTypography typography,
    double margin = 24,
  }) async {
    final chs = chapters ?? book?.chapters ?? [];
    final pages = <ReaderPage>[];

    for (var i = 0; i < chs.length; i++) {
      final chapter = chs[i];
      final spans = <InlineSpan>[];
      if (chapter.title != null && chapter.title.isNotEmpty) {
        spans.add(TextSpan(
          text: chapter.title + '\n\n',
          style: TextStyle(
            fontSize: typography.fontSize + 2,
            fontWeight: FontWeight.bold,
            height: typography.lineHeight,
          ),
        ));
      }
      for (final block in chapter.blocks ?? []) {
        final t = block.text ?? '';
        if (t.isEmpty) continue;
        spans.add(TextSpan(text: t + '\n\n'));
      }
      pages.add(ReaderPage(
        chapterIndex: i,
        startBlockIndex: 0,
        blocks: chapter.blocks,
        spans: spans,
      ));
    }

    if (pages.isEmpty) {
      pages.add(ReaderPage(chapterIndex: 0, startBlockIndex: 0, blocks: [], spans: []));
    }
    return pages;
  }
}
