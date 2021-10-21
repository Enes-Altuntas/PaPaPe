import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  const TitleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold),
            children: [
          TextSpan(text: 'Pa', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'Pa', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'Pe', style: TextStyle(color: Colors.white))
        ]));
  }
}
