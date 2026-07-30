import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_colors.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathshala Management',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.light,
      home: Scaffold(backgroundColor: AppColors.context(context).primaryColor,),
    );
  }
}