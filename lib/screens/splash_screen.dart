import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'root_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.soft,
                ),
                child: const Icon(
                  Icons.train_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'AI Railway Bio-Toilet\nInspection System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'AI Powered Railway Maintenance',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}