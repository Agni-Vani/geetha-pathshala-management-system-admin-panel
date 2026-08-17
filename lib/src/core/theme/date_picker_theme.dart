part of 'app_theme.dart';

class DatePickerThemes {
  static final lightTheme = DatePickerThemeData(
    backgroundColor: AppColors.light().backgroundColor,
    surfaceTintColor: Colors.transparent,
    elevation: 6,
    shadowColor: AppColors.light().shadowColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    headerBackgroundColor: AppColors.light().primaryColor,
    headerForegroundColor: Colors.white,
    headerHeadlineStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    headerHelpStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.white.withValues(alpha: 0.85),
      letterSpacing: 0.4,
    ),
    weekdayStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.light().primaryColor,
    ),
    dayStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    dayShape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    dividerColor: AppColors.light().dividerColor,
    dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.grey.shade300;
      }
      if (states.contains(WidgetState.selected)) {
        return AppColors.light().primaryColor;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.light().primaryColor.withAlpha(125);
      }
      return Colors.transparent; // default background
    }),
    dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.light().primaryColor;
      }
      return AppColors.light().textColor; // default background
    }),

    todayBorder: BorderSide(color: AppColors.light().primaryColor, width: 1.4),
    todayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.light().primaryColor;
      }
      return AppColors.light().primaryColor; // default background
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.light().primaryColor;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.light().primaryColor.withAlpha(125);
      }
      return Colors.transparent; // default background
    }),

    rangeSelectionBackgroundColor: AppColors.light().primaryColor.withAlpha(50),
    yearForegroundColor: WidgetStatePropertyAll(Colors.black),
    yearBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
    yearOverlayColor: WidgetStatePropertyAll(
      AppColors.light().primaryColor.withAlpha(50),
    ),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().grey),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().primaryColor),
    ),
  );

  static final darkTheme = DatePickerThemeData(
    backgroundColor: AppColors.dark().backgroundColor,
    surfaceTintColor: Colors.transparent,
    elevation: 6,
    shadowColor: AppColors.dark().shadowColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    headerBackgroundColor: AppColors.dark().primaryColor,
    headerForegroundColor: Colors.white,
    headerHeadlineStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    headerHelpStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.white.withValues(alpha: 0.85),
      letterSpacing: 0.4,
    ),
    weekdayStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.dark().primaryColor,
    ),
    dayStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    dayShape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    dividerColor: AppColors.dark().dividerColor,
    dayForegroundColor: WidgetStatePropertyAll(Colors.white),
    todayForegroundColor: WidgetStatePropertyAll(Colors.transparent),
    todayBorder: BorderSide(color: AppColors.dark().primaryColor, width: 1.4),
    todayBackgroundColor: WidgetStatePropertyAll(
      AppColors.dark().primaryColor.withAlpha(155),
    ),
    rangeSelectionBackgroundColor: AppColors.dark().primaryColor.withAlpha(50),
    yearForegroundColor: WidgetStatePropertyAll(Colors.white),
    yearBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
    yearOverlayColor: WidgetStatePropertyAll(
      AppColors.dark().primaryColor.withAlpha(50),
    ),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().grey),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().primaryColor),
    ),
  );
}
