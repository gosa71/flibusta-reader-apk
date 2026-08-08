import 'package:flutter/material.dart';
import 'package:flibusta/pages/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Флибуста'),
          ],
        ),
      ),
    );
  }
}
