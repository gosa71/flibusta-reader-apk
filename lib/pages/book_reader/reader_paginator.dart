import 'dart:ui' as ui;

import 'package:flibusta/model/fb2/fb2_book.dart';
import 'package:flutter/material.dart';

/// Типографские настройки читалки — должны применяться идентично и при
/// расчёте пагинации (измерение), и при рендере страницы, иначе разбивка
/// на страницы разойдётся с тем, что реально показывается на экране.
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

  ReaderTypography copyWith({
    double fontSize,
    String fontFamily,
    double lineHeight,
    TextAlign textAlign,
  }) {
    return ReaderTypography(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderTypography &&
      other.fontSize == fontSize &&
      other.fontFamily == fontFamily &&
      other.lineHeight == lineHeight &&
      other.textAlign == textAlign;

  @override
  int get hashCode => fontSize.hashCode ^ fontFamily.hashCode ^ lineHeight.hashCode ^ textAlign.hashCode;
}

/// Одна физическая страница читалки: кусок блоков одной главы,
/// умещающийся в доступную высоту экрана целиком.
class ReaderPage {
  final int chapterIndex;
  final int startBlockIndex;
  final List<Fb2Block> blocks;

  ReaderPage({
    @required this.chapterIndex,
    @required this.startBlockIndex,
    @required this.blocks,
  });
}

/// Разбивает главы книги на страницы, умещающиеся в заданный размер
/// экрана при заданной типографике — как в бумажной книге, а не
/// один бесконечный скролл на главу.
class ReaderPaginator {
  static Future<List<ReaderPage>> paginate({
    @required List<Fb2Chapter> chapters,
    @required double width,
    @required double height,
    @required ReaderTypography typography,
  }) async {
    var pages = <ReaderPage>[];

    for (var chapterIndex = 0; chapterIndex < chapters.length; chapterIndex++) {
      var chapter = chapters[chapterIndex];

      var allBlocks = <Fb2Block>[
        Fb2Block(Fb2BlockType.chapterTitle, chapter.title),
        ...chapter.blocks,
      ];

      var chapterPages = await _paginateChapter(
        chapterIndex: chapterIndex,
        blocks: allBlocks,
        width: width,
        height: height,
        typography: typography,
      );
      pages.addAll(chapterPages);
    }

    if (pages.isEmpty) {
      pages.add(ReaderPage(chapterIndex: 0, startBlockIndex: 0, blocks: []));
    }

    return pages;
  }

  static Future<List<ReaderPage>> _paginateChapter({
    @required int chapterIndex,
    @required List<Fb2Block> blocks,
    @required double width,
    @required double height,
    @required ReaderTypography typography,
  }) async {
    var pages = <ReaderPage>[];
    var currentPageBlocks = <Fb2Block>[];
    var currentPageStartIndex = 0;
    var currentHeight = 0.0;
    const spacing = 12.0;

    void flushPage() {
      if (currentPageBlocks.isEmpty) return;
      pages.add(ReaderPage(
        chapterIndex: chapterIndex,
        startBlockIndex: currentPageStartIndex,
        blocks: List.of(currentPageBlocks),
      ));
      currentPageBlocks = [];
      currentHeight = 0.0;
    }

    for (var i = 0; i < blocks.length; i++) {
      var block = blocks[i];
      var blockHeight = await _measureBlockHeight(block, width, typography);
      var neededHeight = currentHeight == 0 ? blockHeight : currentHeight + spacing + blockHeight;

      if (neededHeight > height && currentPageBlocks.isNotEmpty) {
        flushPage();
        currentPageStartIndex = i;
        neededHeight = blockHeight;
      } else if (currentPageBlocks.isEmpty) {
        currentPageStartIndex = i;
      }

      currentPageBlocks.add(block);
      currentHeight = neededHeight;
    }
    flushPage();

    return pages;
  }

  static Future<double> _measureBlockHeight(
    Fb2Block block,
    double width,
    ReaderTypography typography,
  ) async {
    var fontSize = typography.fontSize;
    switch (block.type) {
      case Fb2BlockType.emptyLine:
        return fontSize;
      case Fb2BlockType.image:
        return _imageHeight(block, width);
      case Fb2BlockType.table:
        var rowCount = block.tableRows?.length ?? 0;
        return rowCount * (fontSize * 1.6) + 16;
      case Fb2BlockType.chapterTitle:
        return _measureText(block.text, width, fontSize + 4, FontWeight.w700, 1.3, typography.fontFamily) + 16;
      case Fb2BlockType.title:
        return _measureText(block.text, width, fontSize + 2, FontWeight.w700, 1.3, typography.fontFamily) + 24;
      case Fb2BlockType.subtitle:
        return _measureText(block.text, width, fontSize, FontWeight.w600, 1.4, typography.fontFamily) + 16;
      case Fb2BlockType.paragraph:
      default:
        return _measureText(block.text ?? '', width, fontSize, FontWeight.w400, typography.lineHeight, typography.fontFamily) + 12;
    }
  }

  static double _imageHeight(Fb2Block block, double width) {
    if (block.imageWidth == null ||
        block.imageHeight == null ||
        block.imageWidth == 0) {
      return width * 0.6;
    }
    var scaledHeight = width * (block.imageHeight / block.imageWidth);
    return scaledHeight + 32;
  }

  static double _measureText(
    String text,
    double width,
    double fontSize,
    FontWeight weight,
    double lineHeight,
    String fontFamily,
  ) {
    if (text == null || text.isEmpty) return fontSize * lineHeight;
    var painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: weight,
          height: lineHeight,
          fontFamily: fontFamily,
        ),
      ),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.height;
  }

  static Future<void> resolveImageSizes(List<Fb2Chapter> chapters) async {
    for (var chapter in chapters) {
      for (var block in chapter.blocks) {
        if (block.type != Fb2BlockType.image || block.imageBytes == null) continue;
        try {
          var codec = await ui.instantiateImageCodec(block.imageBytes);
          var frame = await codec.getNextFrame();
          block.imageWidth = frame.image.width.toDouble();
          block.imageHeight = frame.image.height.toDouble();
        } catch (e) {
          // ignore
        }
      }
    }
  }
}
