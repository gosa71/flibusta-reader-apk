import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/SplashScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Flibusta'),
          ],
        ),
      ),
    );
  }
}
