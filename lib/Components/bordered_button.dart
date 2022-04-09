import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double widthMultiplier;
  final Color borderColor;
  final Color textColor;

  const BorderedButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      required this.widthMultiplier,
      required this.borderColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthMultiplier,
      child: TextButton(
          child: Text(buttonText.toUpperCase(),
              style: TextStyle(fontSize: 14, color: textColor)),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(15)),
              foregroundColor: MaterialStateProperty.all<Color>(borderColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(width: 2, color: borderColor)))),
          onPressed: onPressed),
    );
  }
}
