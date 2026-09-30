part of 'app_theme.dart';

class DatePickerThemes {
  DatePickerThemes._();

  /// Both themes are built from one description so light and dark stay in step.
  static DatePickerThemeData _build(AppColors colors) {
    final primary = colors.primaryColor;
    final onPrimary = Colors.white;
    final disabled = colors.hintColor.withValues(alpha: 0.38);

    return DatePickerThemeData(
      // Must be opaque: a dialog sits over a dark scrim, so the app's
      // translucent surface colour would read as grey here.
      backgroundColor: colors.dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: colors.shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // The grid already separates the header from the days; a line on top of
      // the coloured header only adds clutter.
      dividerColor: Colors.transparent,

      headerBackgroundColor: primary,
      headerForegroundColor: onPrimary,
      headerHeadlineStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: onPrimary,
      ),
      headerHelpStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: onPrimary.withValues(alpha: 0.9),
        letterSpacing: 0.8,
      ),

      weekdayStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: colors.hintColor,
      ),
      dayStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
      // A circle is what a calendar day reads as; a rounded square makes the
      // out-of-range days below look like filled blocks.
      dayShape: const WidgetStatePropertyAll(CircleBorder()),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return Colors.transparent;
        if (states.contains(WidgetState.selected)) return primary;
        if (states.contains(WidgetState.hovered)) {
          return primary.withValues(alpha: 0.14);
        }
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        // Unselectable dates fade out instead of being boxed in grey.
        if (states.contains(WidgetState.disabled)) return disabled;
        if (states.contains(WidgetState.selected)) return onPrimary;
        if (states.contains(WidgetState.hovered)) return primary;
        return colors.textColor;
      }),
      dayOverlayColor: WidgetStatePropertyAll(primary.withValues(alpha: 0.10)),

      todayBorder: BorderSide(color: primary, width: 1.4),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        if (states.contains(WidgetState.hovered)) {
          return primary.withValues(alpha: 0.14);
        }
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabled;
        if (states.contains(WidgetState.selected)) return onPrimary;
        return primary;
      }),

      yearStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      yearShape: const WidgetStatePropertyAll(StadiumBorder()),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        if (states.contains(WidgetState.hovered)) {
          return primary.withValues(alpha: 0.14);
        }
        return Colors.transparent;
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabled;
        if (states.contains(WidgetState.selected)) return onPrimary;
        return colors.textColor;
      }),
      yearOverlayColor: WidgetStatePropertyAll(primary.withValues(alpha: 0.10)),

      rangeSelectionBackgroundColor: primary.withValues(alpha: 0.18),
      rangeSelectionOverlayColor: WidgetStatePropertyAll(
        primary.withValues(alpha: 0.10),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.tileColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),

      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colors.hintColor,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  static final lightTheme = _build(AppColors.light());
  static final darkTheme = _build(AppColors.dark());
}
