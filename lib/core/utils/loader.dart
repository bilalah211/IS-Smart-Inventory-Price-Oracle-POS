import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartinevntary/core/constants/app_assets.dart';

class MyLoader extends StatelessWidget {
  final double? height;
  final Color? color;

  const MyLoader({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    Widget lottie = Lottie.asset(
      AppAssets.loader,
      height: height,
      alignment: Alignment.center,
    );

    if (color != null) {
      return Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
          child: lottie,
        ),
      );
    }

    // Default: Show original Lottie colors (for Splash)
    return Center(child: lottie);
  }
}
