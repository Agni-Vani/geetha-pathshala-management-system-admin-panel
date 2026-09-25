import 'package:flutter/material.dart';

class AppColors {
  AppColors._({
    required this.textColor,
    required this.invertTextColor,
    required this.grey,
    required this.backgroundColor,
    required this.tileColor,
    required this.softGrey,
    required this.iconColor,
    required this.buttonContentColor,
    required this.activeButtonContentColor,
    required this.inActiveButtonColor,
    required this.inActiveButtonContentColor,
    required this.drawerColor,
    required this.borderColor,
    required this.popupBackgroundColor,
    required this.popupContentColor,
    required this.dividerColor,
    required this.tabBarColor,
    required this.shadowColor,
    required this.errorColor,
    required this.bottomNavigationBarColor,
    required this.unselectedLabelColor,
    required this.hintColor,
    required this.labelColor,
    required this.enabledBorderColor,
  });

  static const Color _primaryColor = Color(0xFFff961c);
  static const Color _darkPrimaryColor = Color(0xFFff961c);
  static const Color _secondaryContainerColor = Color(0xfff4ede3);
  static const Color _darkSecondaryContainerColor = Color(0xfff4ede3);
  static const Color _surfaceColor = Color(0xFFFAFCFB);
  static const Color _darkSurfaceColor = Color(0xFF071212);
  static const Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color _errorColor = Color(0xFFBA1A1A);
  static const Color _splashColor = Color(0x2939AEB2);
  static const Color _hintBaseColor = Color(0xFF6E7F80);
  static const Color _iconBaseColor = Color(0xFFff961c);
  static const Color _darkIconBaseColor = Color(0xFFff961c);
  static const Color _bottomNavColor = Color(0xFFFAFCFB);
  static const Color _darkBottomNavColor = Color(0xFF071212);
  static const Color _unselectedLabelColor = Color(0xFF657576);
  static const Color _unselectedTileColor = Color(0xFFE8F5F3);

  static final AppColors _lightInstance = AppColors._(
    textColor: const Color(0xFF172526),
    invertTextColor: Colors.white,
    grey: const Color(0xFF7B8C8D),
    backgroundColor: _surfaceColor.withValues(alpha: 0.9),
    tileColor: _secondaryContainerColor.withValues(alpha: 0.78),
    softGrey: const Color(0xFFEFF5F4),
    iconColor: _iconBaseColor,
    buttonContentColor: Colors.white,
    activeButtonContentColor: Colors.white,
    inActiveButtonColor: _surfaceColor.withValues(alpha: 0.88),
    inActiveButtonContentColor: const Color.fromARGB(255, 111, 112, 112),
    drawerColor: _surfaceColor.withValues(alpha: 0.84),
    borderColor: const Color(0xFFBBCAC9),
    popupBackgroundColor: _surfaceColor.withValues(alpha: 0.94),
    popupContentColor: const Color(0xFF172526),
    dividerColor: const Color(0xFFE0E9E8),
    tabBarColor: _surfaceColor.withValues(alpha: 0.9),
    shadowColor: const Color(0x2400282A),
    errorColor: _errorColor,
    bottomNavigationBarColor: _bottomNavColor.withValues(alpha: 0.9),
    unselectedLabelColor: _unselectedLabelColor,
    hintColor: _hintBaseColor,
    labelColor: _hintBaseColor,
    enabledBorderColor: const Color(0xFFB8C7C6),
  );

  static final AppColors _darkInstance = AppColors._(
    textColor: const Color(0xFFEAF5F4),
    invertTextColor: const Color(0xFF071212),
    grey: const Color(0xFF8CA09F),
    backgroundColor: _darkSurfaceColor.withValues(alpha: 0.86),
    tileColor: _darkSecondaryContainerColor.withValues(alpha: 0.74),
    softGrey: const Color(0xFF1B2929),
    iconColor: _darkIconBaseColor,
    buttonContentColor: const Color(0xFF042021),
    activeButtonContentColor: const Color(0xFF042021),
    inActiveButtonColor: const Color(0xFF122121).withValues(alpha: 0.84),
    inActiveButtonContentColor: const Color(0xFFB9D0CF),
    drawerColor: _darkSurfaceColor.withValues(alpha: 0.82),
    borderColor: const Color(0xFF435656),
    popupBackgroundColor: const Color(0xFF122121).withValues(alpha: 0.92),
    popupContentColor: const Color(0xFFEAF5F4),
    dividerColor: const Color(0xFF1B2929),
    tabBarColor: _darkSurfaceColor.withValues(alpha: 0.86),
    shadowColor: const Color(0x66000000),
    errorColor: const Color(0xFFFFB4AB),
    bottomNavigationBarColor: _darkBottomNavColor.withValues(alpha: 0.86),
    unselectedLabelColor: const Color(0xFF9EAFAE),
    hintColor: const Color(0xFF9EAFAE),
    labelColor: const Color(0xFF9EAFAE),
    enabledBorderColor: const Color(0xFF435656),
  );

  factory AppColors.light() => _lightInstance;

  factory AppColors.dark() => _darkInstance;

  factory AppColors.context(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkInstance
        : _lightInstance;
  }

  final Color textColor;
  final Color invertTextColor;
  final Color grey;
  final Color backgroundColor;
  final Color tileColor;
  final Color softGrey;
  final Color iconColor;
  final Color buttonContentColor;
  final Color activeButtonContentColor;
  final Color inActiveButtonColor;
  final Color inActiveButtonContentColor;
  final Color drawerColor;
  final Color borderColor;
  final Color popupBackgroundColor;
  final Color popupContentColor;
  final Color dividerColor;
  final Color tabBarColor;
  final Color shadowColor;
  final Color errorColor;
  final Color bottomNavigationBarColor;
  final Color unselectedLabelColor;
  final Color hintColor;
  final Color labelColor;
  final Color enabledBorderColor;

  bool get _isDark => identical(this, _darkInstance);

  Color get primaryColor => _isDark ? _darkPrimaryColor : _primaryColor;
  Color get secondaryColor => tileColor;
  Color get surfaceColor => backgroundColor;
  Color get appBackgroundColor =>
      _isDark ? _darkSurfaceColor : _backgroundColor;
  Color get splashColor => _splashColor;
  Color get activeButtonColor => primaryColor;
  Color get buttonColor => primaryColor;
  Color get fillColor => backgroundColor;
  Color get focusedBorderColor => primaryColor;
  Color get unselectedTileColor => _unselectedTileColor;

  /// Deep maroon used for sidebar navigation and the Om badge — the app's
  /// second brand colour alongside the orange [primaryColor].
  Color get maroonColor =>
      _isDark ? const Color(0xFFD99B85) : const Color(0xFF6E2C1E);

  /// Foreground on a solid [maroonColor] fill — the dark theme's maroon is a
  /// light clay, where white would wash out.
  Color get onMaroonColor =>
      _isDark ? const Color(0xFF3A1409) : Colors.white;

  /// Warm parchment fill for registry cards — a touch creamier than
  /// [backgroundColor] so a card reads as paper laid on the page.
  Color get cardSurfaceColor =>
      _isDark ? const Color(0xFF13201F) : const Color(0xFFFFFCF6);

  /// Gold used for card borders and the corner flourishes.
  Color get ornamentColor =>
      _isDark ? const Color(0xFF6B5836) : const Color(0xFFE6CDA4);

  /// Soft peach behind avatars and small icon tiles.
  Color get softAccentColor =>
      _isDark ? const Color(0xFF3A2A16) : const Color(0xFFFBE6CC);

  /// Opaque surface for dialogs and pop-ups.
  ///
  /// [backgroundColor] is deliberately translucent so panels blend with the
  /// illustrated app background — but a dialog sits above a dark scrim, where
  /// that translucency reads as dirty grey. Dialogs use this instead.
  Color get dialogBackgroundColor =>
      _isDark ? const Color(0xFF0E1C1C) : const Color(0xFFFFFCF7);
}
