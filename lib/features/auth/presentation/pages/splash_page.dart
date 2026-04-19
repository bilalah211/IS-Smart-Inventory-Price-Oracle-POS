import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartinevntary/core/constants/app_assets.dart';
import 'package:smartinevntary/core/constants/app_strings.dart';
import 'package:smartinevntary/core/services/local_storage.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';
import 'package:smartinevntary/core/theme/app_textstyle.dart';
import 'package:smartinevntary/core/utils/loader.dart';
import 'package:smartinevntary/features/auth/presentation/pages/login_page.dart';
import 'package:smartinevntary/features/products/presentation/pages/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  LocalStorageServices localStorage = LocalStorageServices();

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  void checkLogin() async {
    final remember = await localStorage.getData();
    final user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 3));

    if (remember && user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Spacer(),
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,

                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 3,
                      ),
                      borderRadius: BorderRadiusGeometry.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      child: Image.asset(
                        height: 180,
                        AppAssets.appLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppStrings.splashTitle,
                    style: AppTextStyles.headerTitle,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: .end,

                crossAxisAlignment: .center,
                children: [SizedBox(height: 100, child: MyLoader())],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
