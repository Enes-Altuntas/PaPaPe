import 'package:bulovva/Constants/colors_constants.dart';
import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  const TitleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
                fontSize: 45.0,
                color: ColorConstants.instance.textOnColor,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'Pa',
              style: TextStyle(
                color: ColorConstants.instance.inactiveColor,
              )),
          TextSpan(
              text: 'Pa',
              style: TextStyle(
                color: ColorConstants.instance.waitingColor,
              )),
          TextSpan(
              text: 'Pe',
              style: TextStyle(
                color: ColorConstants.instance.activeColor,
              ))
        ]));
  }
}
