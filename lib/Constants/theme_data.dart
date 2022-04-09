import 'package:flutter/material.dart';

import 'colors_constants.dart';

final ThemeData myRestThemeData = ThemeData(
  colorScheme: ThemeData()
      .colorScheme
      .copyWith(primary: ColorConstants.instance.primaryColor),
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: ColorConstants.instance.whiteContainer,
);
