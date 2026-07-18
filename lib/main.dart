import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RailBioInspectApp());
}

class RailBioInspectApp extends StatelessWidget {
  const RailBioInspectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Railway Bio-Toilet Inspection System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SplashScreen(),
      builder: (context, child) {
        // Different phones ship with very different default system font
        // scales (and users can crank accessibility text size up further).
        // Clamp it to a safe range so layouts stay stable across devices
        // instead of overflowing on phones with larger text settings,
        // while still respecting some user preference.
        final mediaQuery = MediaQuery.of(context);
        final clampedScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.3,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScaler),
          child: child!,
        );
      },
    );
  }
}