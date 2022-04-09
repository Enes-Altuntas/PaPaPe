import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/waiting.json',
            width: MediaQuery.of(context).size.width / 1.8),
      ),
    );
  }
}
