import 'package:flutter/material.dart';

import '../../../../core/shared/widget/app_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_route_names.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RegistryRouteNames.pathshalas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                child: Icon(
                  Icons.temple_hindu_outlined,
                  color: colors.primaryColor,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'গীতা পাঠশালা',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pathshala Management',
                style: TextStyle(fontSize: 13, color: colors.hintColor),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
