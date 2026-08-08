import 'package:flutter/material.dart';

class AdvancedSearchPage extends StatelessWidget {
  static const routeName = '/AdvancedSearchPage';
  final dynamic advancedSearchParams;

  const AdvancedSearchPage({Key key, this.advancedSearchParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расширенный поиск')),
      body: Center(child: Text('Advanced Search')),
    );
  }
}
