import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  const TitleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('PaPaPe',
        style: TextStyle(
          fontSize: 45.0,
          fontFamily: 'Armatic',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ));
  }
}
