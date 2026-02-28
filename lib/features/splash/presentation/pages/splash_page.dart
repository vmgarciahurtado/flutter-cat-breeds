import 'package:cat_breeds/core/constants/assets.dart';
import 'package:cat_breeds/core/constants/strings.dart';
import 'package:cat_breeds/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go(AppRoutes.breeds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: -50, end: 0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(opacity: (value + 50) / 50, child: child),
                );
              },
              child: Text(
                AppStrings.appName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            Lottie.asset(
              AppAssets.pawsPetLottie,
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
