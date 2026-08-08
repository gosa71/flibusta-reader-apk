import 'package:flutter/material.dart';

class InternetChecker extends StatelessWidget {
  final Widget child;
  const InternetChecker({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) => child ?? SizedBox.shrink();
}
