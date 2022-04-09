import 'package:bulovva/Constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotFound extends StatelessWidget {
  final IconData notFoundIcon;
  final String notFoundText;

  const NotFound({
    Key? key,
    required this.notFoundIcon,
    required this.notFoundText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(notFoundIcon,
                size: 60.0, color: ColorConstants.instance.primaryColor),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                notFoundText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    color: ColorConstants.instance.hintColor,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
