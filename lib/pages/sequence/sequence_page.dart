import 'package:flutter/material.dart';

class SequencePage extends StatelessWidget {
  static const routeName = '/SequencePage';
  final dynamic sequence;
  final dynamic sequenceId;

  const SequencePage({Key key, this.sequence, this.sequenceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Серия')),
      body: Center(child: Text('Sequence: ${sequenceId ?? sequence}')),
    );
  }
}
