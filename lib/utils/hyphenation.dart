import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Расстановка мягких переносов (U+00AD) в русском тексте.
///
/// Порт алгоритма Liang/Hypher (тот же, что использует TeX и большинство
/// браузеров) на Dart, с реальными русскоязычными TeX-паттернами переноса
/// (assets/hyphenation/ru.json, источник — пакет hyphenation.ru).
///
/// U+00AD — стандартный юникодный "мягкий перенос": невидим, пока слово
/// не переносится на новую строку, но если движок переноса строк решает
/// разбить строку в этом месте — показывает дефис. Flutter/Skia уважает
/// его при построении параграфа, так что дополнительно ничего не рисуем.
class Hyphenator {
  static Hyphenator _cached;
  static Future<Hyphenator> _loading;

  final _TrieNode _trie;
  final int _leftMin;
  final int _rightMin;

  Hyphenator._(this._trie, this._leftMin, this._rightMin);

  static Future<Hyphenator> load() {
    if (_cached != null) return Future.value(_cached);
    _loading ??= _doLoad();
    return _loading;
  }

  static Future<Hyphenator> _doLoad() async {
    try {
      var raw = await rootBundle.loadString('assets/hyphenation/ru.json');
      var data = json.decode(raw) as Map<String, dynamic>;
      var rawPatterns = data['patterns'] as Map<String, dynamic>;
      var patterns = rawPatterns.map((k, v) => MapEntry(k, v as String));
      var trie = _buildTrie(patterns);
      _cached = Hyphenator._(
        trie,
        (data['leftmin'] as num)?.toInt() ?? 2,
        (data['rightmin'] as num)?.toInt() ?? 2,
      );
    } catch (e) {
      // Словарь не загрузился — читалка не должна из-за этого падать,
      // просто работаем без переносов (текст останется как есть).
      _cached = Hyphenator._(_TrieNode(), 2, 2);
    }
    return _cached;
  }

  static _TrieNode _buildTrie(Map<String, String> patternsBySize) {
    var root = _TrieNode();

    patternsBySize.forEach((sizeStr, concatenated) {
      var size = int.tryParse(sizeStr);
      if (size == null || size <= 0) return;

      for (var i = 0; i < concatenated.length; i += size) {
        var end = (i + size < concatenated.length) ? i + size : concatenated.length;
        var token = concatenated.substring(i, end);
        if (token.isEmpty) continue;

        var chars = token.replaceAll(RegExp(r'[0-9]'), '');
        var pointsParts = token.split(RegExp(r'[^0-9]'));
        var points = pointsParts.map((p) => p.isEmpty ? 0 : int.parse(p)).toList();

        var node = root;
        for (var rune in chars.runes) {
          node = node.children.putIfAbsent(rune, () => _TrieNode());
        }
        node.points = points;
      }
    });

    return root;
  }

  /// Вставляет мягкие переносы во все русские слова длиннее [minLength]
  /// символов. Короткие слова не трогаем — переносить 4-буквенное слово
  /// незачем и выглядит некрасиво в любой нормальной читалке.
  String hyphenateText(String text, {int minLength = 5}) {
    if (text == null || text.isEmpty) return text;
    return text.replaceAllMapped(RegExp(r'[а-яА-ЯёЁ]+'), (match) {
      var word = match.group(0);
      if (word.length <= minLength) return word;
      return _hyphenateWord(word).join('\u00AD');
    });
  }

  List<String> _hyphenateWord(String word) {
    var padded = '_' + word + '_';
    var lowerRunes = padded.toLowerCase().runes.toList();
    var originalRunes = padded.runes.toList();
    var wordLength = lowerRunes.length;
    var points = List<int>.filled(wordLength, 0);

    for (var i = 0; i < wordLength; i++) {
      var node = _trie;
      for (var j = i; j < wordLength; j++) {
        var child = node.children[lowerRunes[j]];
        if (child == null) break;
        node = child;
        if (node.points != null) {
          for (var k = 0; k < node.points.length; k++) {
            var idx = i + k;
            if (idx < wordLength && node.points[k] > points[idx]) {
              points[idx] = node.points[k];
            }
          }
        }
      }
    }

    var result = <String>[''];
    for (var i = 1; i < wordLength - 1; i++) {
      if (i > _leftMin && i < (wordLength - _rightMin) && points[i] % 2 == 1) {
        result.add(String.fromCharCode(originalRunes[i]));
      } else {
        result[result.length - 1] += String.fromCharCode(originalRunes[i]);
      }
    }
    return result;
  }
}

class _TrieNode {
  Map<int, _TrieNode> children = {};
  List<int> points;
}
