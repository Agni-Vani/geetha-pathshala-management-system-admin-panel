import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/assets.dart';
import '../../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool blendWithSidebar;

  /// False for pages that paint the illustration themselves (e.g. fitted
  /// below their own header) so it isn't drawn twice.
  final bool showImage;

  const AppBackground({
    super.key,
    required this.child,
    this.blendWithSidebar = false,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarSurface = Color.alphaBlend(
      colors.drawerColor,
      colors.appBackgroundColor,
    );

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        fit: StackFit.expand,
        children: [
          Container(color: colors.appBackgroundColor),
          if (showImage)
            IgnorePointer(
              child: Opacity(
                opacity: isDark ? 0.08 : 0.16,
                child: Image.asset(
                  Assets.backgroundImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.appBackgroundColor.withValues(
                      alpha: isDark ? 0.84 : 0.72,
                    ),
                    colors.appBackgroundColor.withValues(
                      alpha: isDark ? 0.9 : 0.8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (blendWithSidebar)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (constraints.maxHeight * .32).clamp(160.0, 280.0),
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        sidebarSurface,
                        sidebarSurface.withValues(alpha: .9),
                        sidebarSurface.withValues(alpha: .55),
                        sidebarSurface.withValues(alpha: .15),
                        sidebarSurface.withValues(alpha: 0),
                      ],
                      stops: const [0, .18, .5, .8, 1],
                    ),
                  ),
                ),
              ),
            ),
          if (blendWithSidebar && !AppSizes.isCompact(context))
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: (constraints.maxWidth * .08).clamp(40.0, 96.0),
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        sidebarSurface,
                        sidebarSurface.withValues(alpha: .65),
                        sidebarSurface.withValues(alpha: 0),
                      ],
                      stops: const [0, .4, 1],
                    ),
                  ),
                ),
              ),
            ),
          if (blendWithSidebar)
            Positioned(
              top: 0,
              right: 0,
              width: (constraints.maxWidth * .36).clamp(160.0, 440.0),
              height: (constraints.maxHeight * .25).clamp(120.0, 210.0),
              child: IgnorePointer(
                child: ShaderMask(
                  shaderCallback: (bounds) => const RadialGradient(
                    center: Alignment(.25, -.15),
                    radius: .85,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0, .3, 1],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Colors.transparent],
                      stops: [0, .4, 1],
                    ).createShader(bounds),
                    blendMode: BlendMode.dstIn,
                    child: Opacity(
                      opacity: isDark ? .08 : .16,
                      child: Image.asset(
                        Assets.krishnaImage,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

/// The app illustration with the same opacity and soft wash [AppBackground]
/// uses, for pages that pin it below their own header instead of letting the
/// shell paint it behind everything.
class AppBackgroundIllustration extends StatelessWidget {
  const AppBackgroundIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: isDark ? 0.08 : 0.16,
            child: Image.asset(
              Assets.backgroundImage,
              // cover + topCenter: full width on wide screens (same as
              // fitWidth) but still reaches the bottom on tall, narrow ones
              // instead of leaving a blank band under the image.
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.appBackgroundColor.withValues(
                    alpha: isDark ? 0.84 : 0.72,
                  ),
                  colors.appBackgroundColor.withValues(
                    alpha: isDark ? 0.9 : 0.8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints [AppBackgroundIllustration] behind [child], starting just below the
/// widget tagged with [anchorKey] (a header, filter bar or divider) and
/// running to the bottom edge.
///
/// The anchor usually lives inside a scroll view, so its position is measured
/// relative to [contentKey] — the root of the scrolled content — plus
/// [contentTop], the padding above that root. That keeps the image pinned
/// where the anchor rests when the page is scrolled to the top.
class IllustrationBelowAnchor extends StatefulWidget {
  final GlobalKey contentKey;
  final GlobalKey anchorKey;
  final double contentTop;

  /// Extra space between the anchor's bottom edge and the image.
  final double gap;
  final Widget child;

  const IllustrationBelowAnchor({
    super.key,
    required this.contentKey,
    required this.anchorKey,
    required this.child,
    this.contentTop = 0,
    this.gap = 0,
  });

  @override
  State<IllustrationBelowAnchor> createState() =>
      _IllustrationBelowAnchorState();
}

class _IllustrationBelowAnchorState extends State<IllustrationBelowAnchor> {
  double? _top;

  void _measure() {
    final content =
        widget.contentKey.currentContext?.findRenderObject() as RenderBox?;
    final anchor =
        widget.anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (content == null || anchor == null) return;
    if (!content.hasSize || !anchor.hasSize) return;
    final top =
        widget.contentTop +
        widget.gap +
        anchor
            .localToGlobal(Offset(0, anchor.size.height), ancestor: content)
            .dy;
    if (_top == null || (_top! - top).abs() > .5) {
      setState(() => _top = top);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Depend on the window size so a resize (which can reflow the header)
    // triggers a fresh measurement.
    MediaQuery.sizeOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measure();
    });
    return Stack(
      children: [
        if (_top != null)
          Positioned(
            top: _top,
            left: 0,
            right: 0,
            bottom: 0,
            child: const AppBackgroundIllustration(),
          ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
