import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import 'app_colors.dart';

/// Single source of truth for form field visuals (borders, padding and the
/// spacing around prefix/suffix icons) so every field in the app looks alike.
///
/// Flutter drops the horizontal [InputDecoration.contentPadding] on the side
/// where an icon lives, so a bare `Icon` ends up glued to the text. Always
/// build icons through [prefixIcon] / [suffixIcon] instead of passing a raw
/// `Icon`, and the gap stays consistent everywhere.
class AppFieldDecoration {
  AppFieldDecoration._();

  static const double iconSize = 18;

  /// Border edge -> icon.
  static const double _iconEdgeGap = 14;

  /// Icon -> text.
  static const double _iconTextGap = 10;

  static const BorderRadius borderRadius = AppSizes.textFieldBorderRadius;

  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );

  /// Lets the surrounding [Padding] control the gap instead of Flutter's
  /// default 48x48 icon box.
  static const BoxConstraints iconConstraints = BoxConstraints(
    minWidth: 0,
    minHeight: 0,
  );

  static Widget prefixIcon(
    BuildContext context,
    IconData icon, {
    double size = iconSize,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _iconEdgeGap,
        right: _iconTextGap,
      ),
      child: Icon(
        icon,
        size: size,
        color: color ?? AppColors.context(context).hintColor,
      ),
    );
  }

  static Widget suffixIcon(
    BuildContext context,
    IconData icon, {
    double size = iconSize,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _iconTextGap,
        right: _iconEdgeGap,
      ),
      child: Icon(
        icon,
        size: size,
        color: color ?? AppColors.context(context).hintColor,
      ),
    );
  }

  static InputDecoration build(
    BuildContext context, {
    String? hint,
    IconData? prefix,
    IconData? suffix,
    Widget? suffixWidget,
    EdgeInsets? padding,
    bool filled = true,
    bool isDense = false,
  }) {
    final colors = AppColors.context(context);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
      isDense: isDense,
      filled: filled,
      fillColor: colors.tileColor,
      contentPadding: padding ?? contentPadding,
      prefixIcon: prefix == null ? null : prefixIcon(context, prefix),
      prefixIconConstraints: iconConstraints,
      suffixIcon: suffixWidget ??
          (suffix == null ? null : suffixIcon(context, suffix)),
      suffixIconConstraints: iconConstraints,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.errorColor),
      ),
    );
  }
}
