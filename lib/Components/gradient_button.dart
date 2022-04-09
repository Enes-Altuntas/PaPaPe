import 'package:myrest/Constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String buttonText;
  final String? fontFamily;
  final double fontSize;
  final double widthMultiplier;
  final Color start;
  final Color end;

  const GradientButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.buttonText,
      this.fontFamily,
      required this.start,
      required this.end,
      required this.fontSize,
      required this.widthMultiplier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widthMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: LinearGradient(
              colors: [start, end],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: ColorConstants.instance.iconOnColor,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(buttonText,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.instance.textOnColor,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
