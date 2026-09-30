import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Parchment card with a gold hairline border and a small floral flourish in
/// each corner — the shared card shell for registry listings.
///
/// The flourishes are painted rather than shipped as images so they stay crisp
/// at any size and follow the theme's [AppColors.ornamentColor].
class OrnamentalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const OrnamentalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: colors.cardSurfaceColor,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: colors.cardSurfaceColor,
            borderRadius: radius,
            border: Border.all(color: colors.ornamentColor),
            boxShadow: [
              BoxShadow(
                color: colors.shadowColor.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _CornerFlourishPainter(
              color: colors.ornamentColor,
              cornerRadius: borderRadius,
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Draws one motif per corner: an inner arc echoing the card radius, a small
/// leaf tucked inside it and a dot. The motif is authored once for the
/// top-left corner and mirrored into the other three.
class _CornerFlourishPainter extends CustomPainter {
  final Color color;
  final double cornerRadius;

  const _CornerFlourishPainter({required this.color, required this.cornerRadius});

  /// How far the motif sits from the card edge.
  static const double _inset = 6;

  /// Length of the motif's arms along each edge.
  static const double _arm = 15;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Nothing to decorate if the card is too small to hold the motif.
    if (size.width < _arm * 3 || size.height < _arm * 3) return;

    void drawCorner(double dx, double dy, double sx, double sy) {
      canvas.save();
      canvas.translate(dx, dy);
      canvas.scale(sx, sy);

      final r = cornerRadius - _inset;
      final arc = Path()
        ..moveTo(0, _arm)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(_arm, 0);
      canvas.drawPath(arc, stroke);

      // Leaf curling inwards from the arc.
      final leaf = Path()
        ..moveTo(4, _arm - 1)
        ..quadraticBezierTo(4, 4, _arm - 1, 4)
        ..quadraticBezierTo(8, 6, 4, _arm - 1);
      canvas.drawPath(leaf, stroke);

      canvas.drawCircle(const Offset(_arm + 3.5, 3.5), 1.3, fill);
      canvas.drawCircle(const Offset(3.5, _arm + 3.5), 1.3, fill);

      canvas.restore();
    }

    drawCorner(_inset, _inset, 1, 1);
    drawCorner(size.width - _inset, _inset, -1, 1);
    drawCorner(_inset, size.height - _inset, 1, -1);
    drawCorner(size.width - _inset, size.height - _inset, -1, -1);
  }

  @override
  bool shouldRepaint(_CornerFlourishPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.cornerRadius != cornerRadius;
}
