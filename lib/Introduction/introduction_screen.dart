import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Constants/localization_constants.dart';
import 'package:myrest/Wrappers/provider_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Providers/locale_provider.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  int localeSelector = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.instance.whiteContainer,
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  if (localeSelector ==
                      LocalizationConstant.locals.length - 1) {
                    localeSelector = 0;
                  } else {
                    localeSelector += 1;
                  }
                });
                context.read<LocaleProvider>().setLocale(
                    LocalizationConstant.locals[localeSelector].locale);
              },
              child: Text(
                  LocalizationConstant.locals[localeSelector].localeShort,
                  style: TextStyle(
                      color: ColorConstants.instance.primaryColor,
                      fontWeight: FontWeight.bold)))
        ],
        elevation: 0,
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Text(
                AppLocalizations.of(context)!.introduction_title_1,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  AppLocalizations.of(context)!.introduction_description_1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            image: Lottie.asset('assets/lottie/introduction6.json'),
          ),
          PageViewModel(
            titleWidget: Text(
                AppLocalizations.of(context)!.introduction_title_2,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  AppLocalizations.of(context)!.introduction_description_2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            image: Lottie.asset('assets/lottie/introduction2.json'),
          ),
          PageViewModel(
            titleWidget: Text(
                AppLocalizations.of(context)!.introduction_title_3,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  AppLocalizations.of(context)!.introduction_description_3,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            image: Lottie.asset('assets/lottie/introduction3.json'),
          ),
          PageViewModel(
            titleWidget: Text(
                AppLocalizations.of(context)!.introduction_title_4,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  AppLocalizations.of(context)!.introduction_description_4,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            image: Lottie.asset('assets/lottie/introduction4.json'),
          ),
          PageViewModel(
            titleWidget: Text(
                AppLocalizations.of(context)!.introduction_title_5,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
            bodyWidget: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  AppLocalizations.of(context)!.introduction_description_5,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            image: Lottie.asset('assets/lottie/introduction5.json'),
          ),
        ],
        onDone: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool("first_time", false);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProviderWrapper()));
        },
        showBackButton: true,
        back: const Icon(Icons.arrow_back_ios),
        next: const Icon(Icons.arrow_forward_ios),
        done: Text(AppLocalizations.of(context)!.done,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: ColorConstants.instance.primaryColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
