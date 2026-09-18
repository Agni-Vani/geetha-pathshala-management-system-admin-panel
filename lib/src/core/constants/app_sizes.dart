import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._(); // Private constructor to prevent instantiation

  // Page layout
  /// Below this width a page is laid out for a phone.
  static const double compactBreakpoint = 640;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  /// Outer padding of a page's scroll body. 24 on every edge spends a lot of
  /// a ~390pt phone screen on nothing, so it tightens there.
  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.all(isCompact(context) ? 16 : 24);

  /// Vertical gap between a page's major sections (header, filters, grid…).
  static double sectionGap(BuildContext context) =>
      isCompact(context) ? 16 : 24;

  // Padding and Margin Constants
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double smallMargin = 8.0;
  static const double mediumMargin = 16.0;
  static const double largeMargin = 24.0;
  static const double extraLargeMargin = 32.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // Button Heights
  static const double smallButtonHeight = 40.0;
  static const double mediumButtonHeight = 48.0;
  static const double largeButtonHeight = 56.0;

  // Border Radius
  static const BorderRadius textFieldBorderRadius = BorderRadius.all(
    Radius.circular(10.0),
  );
  /// Corner radius shared by every tappable control — buttons, sidebar items,
  /// top-bar chips — so they all read as one family.
  static const BorderRadius rectangleButtonRadius = BorderRadius.all(
    Radius.circular(12.0),
  );
  static const BorderRadius smallRectangleTileRadius = BorderRadius.all(
    Radius.circular(4.0),
  );
  static const BorderRadius bigRectangleTileRadius = BorderRadius.all(
    Radius.circular(8.0),
  );
  static const BorderRadius rectangleTileRadiusMax = BorderRadius.all(
    Radius.circular(12.0),
  );
  static const BorderRadius smallBorderRadius = BorderRadius.all(
    Radius.circular(8.0),
  );
  static const BorderRadius verySmallBorderRadius = BorderRadius.all(
    Radius.circular(2.0),
  );
  static const BorderRadius mediumBorderRadius = BorderRadius.all(
    Radius.circular(14.0),
  );
  static const BorderRadius largeBorderRadius = BorderRadius.all(
    Radius.circular(24.0),
  );
  static BorderRadius maxCircularRadius = BorderRadius.circular(600000000000);

  // Elevations
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;

  // Text Sizes
  static const double smallTextSize = 10.0;
  static const double mediumTextSize = 14.0;
  static const double largeTextSize = 18.0;
  static const double extraLargeTextSize = 22.0;

  // Other Common Sizes
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 56.0;
  static const double avatarRadius = 40.0;

  // Spacing Constants (between widgets)
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 24.0;

  // Image Sizes
  static const double smallImageSize = 48.0;
  static const double mediumImageSize = 72.0;
  static const double largeImageSize = 120.0;
  static const double extraLargeImageSize = 160.0;

  // Dividers
  static const double thinDivider = 1.0;
  static const double thickDivider = 2.0;

  // App Specific Sizes (for app-wide consistency)
  static const double cardCornerRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double dialogWidth = 300.0;
  static const double buttonWidth = 160.0;
  static const double drawerWidth = 280.0;

  // Insets for various UI elements
  static const EdgeInsets smallInsets = EdgeInsets.all(smallPadding);
  static const EdgeInsets mediumInsets = EdgeInsets.all(mediumPadding);
  static const EdgeInsets largeInsets = EdgeInsets.all(largePadding);
  static const EdgeInsets horizontalInsets = EdgeInsets.symmetric(
    horizontal: mediumPadding,
  );
  static const EdgeInsets verticalInsets = EdgeInsets.symmetric(
    vertical: mediumPadding,
  );
}
