import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  static const routeName = '/IntroPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Intro')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
      ),
    );
  }
}
