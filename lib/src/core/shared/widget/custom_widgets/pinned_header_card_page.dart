import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../theme/app_colors.dart';
import '../app_background.dart';

/// Body skeleton shared by the list pages (students, teachers, attendance,
/// notices…): the [header] stays put, closed by a divider that sits flush on
/// the top edge of the background illustration, and one card below fills the
/// rest of the page and holds [card], which scrolls inside it.
///
/// Pages using it must turn the shell's own illustration off
/// (`showBackgroundImage: false`) so it isn't drawn twice.
class PinnedHeaderCardPage extends StatelessWidget {
  /// Breadcrumbs, title and actions. Not scrolled.
  final Widget header;

  /// The card's contents — a scrollable, padded with [cardInset].
  final Widget card;

  const PinnedHeaderCardPage({
    super.key,
    required this.header,
    required this.card,
  });

  /// Padding between the card's edge and its contents.
  static double cardInset(BuildContext context) =>
      AppSizes.isCompact(context) ? 12 : 20;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final padding = AppSizes.pagePadding(context);
    final gap = AppSizes.sectionGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            padding.top,
            padding.right,
            gap / 2,
          ),
          child: header,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: colors.dividerColor.withValues(alpha: .7),
        ),
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: AppBackgroundIllustration()),
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    padding.left,
                    gap,
                    padding.right,
                    padding.bottom,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.ornamentColor.withValues(alpha: .6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadowColor.withValues(alpha: .06),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: card,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
