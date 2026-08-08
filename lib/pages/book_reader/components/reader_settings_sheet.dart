import 'package:flibusta/ds_controls/theme.dart';
import 'package:flibusta/ds_controls/ui/show_modal_bottom_sheet.dart';
import 'package:flibusta/pages/book_reader/reader_theme.dart';
import 'package:flutter/material.dart';

const kReaderMarginPresets = [16.0, 24.0, 40.0];
const kReaderMarginLabels = ['Узкие', 'Обычные', 'Широкие'];

Future<void> showReaderSettingsMBS(
  BuildContext context, {
  @required double fontSize,
  @required int themeIndex,
  @required double brightness,
  @required double margin,
  @required void Function(double fontSize, int themeIndex, double brightness, double margin) onChanged,
}) async {
  await showDsModalBottomSheet(
    context: context,
    title: 'Настройки читалки',
    builder: (context) {
      return _ReaderSettingsContent(
        fontSize: fontSize,
        themeIndex: themeIndex,
        brightness: brightness,
        margin: margin,
        onChanged: onChanged,
      );
    },
  );
}

class _ReaderSettingsContent extends StatefulWidget {
  final double fontSize;
  final int themeIndex;
  final double brightness;
  final double margin;
  final void Function(double, int, double, double) onChanged;

  const _ReaderSettingsContent({
    this.fontSize,
    this.themeIndex,
    this.brightness,
    this.margin,
    this.onChanged,
  });

  @override
  __ReaderSettingsContentState createState() => __ReaderSettingsContentState();
}

class __ReaderSettingsContentState extends State<_ReaderSettingsContent> {
  double _fontSize;
  int _themeIndex;
  double _brightness;
  double _margin;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.fontSize;
    _themeIndex = widget.themeIndex;
    _brightness = widget.brightness;
    _margin = widget.margin;
  }

  void _notify() {
    widget.onChanged(_fontSize, _themeIndex, _brightness, _margin);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Размер шрифта: ${_fontSize.toStringAsFixed(0)}'),
          Slider(
            value: _fontSize,
            min: 12,
            max: 32,
            divisions: 20,
            onChanged: (v) {
              setState(() => _fontSize = v);
              _notify();
            },
          ),
          SizedBox(height: 16),
          Text('Тема'),
          Wrap(
            spacing: 8,
            children: List.generate(ReaderTheme.themes.length, (i) {
              final t = ReaderTheme.themes[i];
              return ChoiceChip(
                label: Text('Тема ${i + 1}'),
                selected: _themeIndex == i,
                selectedColor: t.backgroundColor,
                onSelected: (_) {
                  setState(() => _themeIndex = i);
                  _notify();
                },
              );
            }),
          ),
          SizedBox(height: 16),
          Text('Яркость: ${(_brightness * 100).toStringAsFixed(0)}%'),
          Slider(
            value: _brightness,
            min: 0.3,
            max: 1.0,
            onChanged: (v) {
              setState(() => _brightness = v);
              _notify();
            },
          ),
          SizedBox(height: 16),
          Text('Поля'),
          Wrap(
            spacing: 8,
            children: List.generate(kReaderMarginPresets.length, (i) {
              return ChoiceChip(
                label: Text(kReaderMarginLabels[i]),
                selected: _margin == kReaderMarginPresets[i],
                onSelected: (_) {
                  setState(() => _margin = kReaderMarginPresets[i]);
                  _notify();
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
