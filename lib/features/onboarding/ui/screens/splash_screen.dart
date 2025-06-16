import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/helpers/shared_pref_helper.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/home_screen.dart';
import 'package:invoice_simple/features/onboarding/ui/screens/onboard_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        bool isNotFirstLogin = await SharedPrefHelper.getBool(
          AppConstants.prefsNotFirstLogin,
        );
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.remove(AppConstants.prefsNotFirstLogin);

        if (mounted) {
          if (isNotFirstLogin) {
            context.go(HomeScreen.routePath);
          } else {
            context.go(OnboardScreen.routePath);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
