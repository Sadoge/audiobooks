import 'dart:math' as math;

import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:flutter/material.dart';

/// The brushed housing bar every screen is titled by.
///
/// A plain [AppBar] underneath, so the platform keeps the back button, the
/// title overflow, and the safe area; only the ground it sits on is ours.
class ChromeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChromeAppBar({required this.title, this.actions, super.key});

  final Widget title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final chrome = RetroChrome.of(context);
    return AppBar(
      title: title,
      actions: actions,
      // Expanded, because the flexible space is laid out loosely and a bare
      // decoration would collapse to nothing behind the toolbar.
      flexibleSpace: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: chrome.chrome,
            border: Border(
              bottom: BorderSide(
                color: chrome.chromeEdge,
                width: AppStroke.hairline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A moulded bezel around artwork, the way a cover sat behind a window.
class ChromeFrame extends StatelessWidget {
  const ChromeFrame({
    required this.child,
    this.radius = AppRadii.coverUnit,
    this.thickness = AppStroke.bezel,
    super.key,
  });

  final Widget child;
  final double radius;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final chrome = RetroChrome.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: chrome.chrome,
        borderRadius: BorderRadius.circular(radius + thickness),
        border: Border.all(color: chrome.chromeEdge, width: AppStroke.hairline),
      ),
      child: Padding(
        padding: EdgeInsets.all(thickness),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: child,
        ),
      ),
    );
  }
}

/// The recessed readout: a pane of glass sunk into the housing.
class ScreenPanel extends StatelessWidget {
  const ScreenPanel({
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final chrome = RetroChrome.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: chrome.screenFill,
        borderRadius: AppRadii.screen,
        border: Border.all(color: chrome.screenEdge, width: AppStroke.hairline),
      ),
      child: child,
    );
  }
}

/// A small pressable key, for the controls that are not on the wheel.
class ChromeKey extends StatelessWidget {
  const ChromeKey({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chrome = RetroChrome.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: chrome.keyFace,
        borderRadius: AppRadii.control,
        border: Border.all(color: chrome.chromeEdge, width: AppStroke.hairline),
      ),
      child: child,
    );
  }
}

/// The transport wheel.
///
/// The face is painted; every control on it is an ordinary button placed over
/// the paint, so tooltips, focus, touch-target sizes, and screen-reader
/// semantics are the platform's and not a drawing's.
class ClickWheel extends StatelessWidget {
  const ClickWheel({
    required this.centre,
    this.north,
    this.south,
    this.west,
    this.east,
    this.diameter = maxDiameter,
    super.key,
  });

  static const double maxDiameter = 244;
  static const double minDiameter = 200;

  /// Where a control sits between the well and the rim.
  static const double _band = 0.88;

  final Widget centre;
  final Widget? north;
  final Widget? south;
  final Widget? west;
  final Widget? east;
  final double diameter;

  /// The largest wheel [width] has room for, never past [limit].
  static double diameterFor(double width, {double limit = maxDiameter}) =>
      width.isFinite ? math.min(limit, math.max(minDiameter, width)) : limit;

  @override
  Widget build(BuildContext context) {
    final chrome = RetroChrome.of(context);
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ClickWheelPainter(
                face: chrome.wheel,
                edge: chrome.wheelEdge,
                well: chrome.wheelWell,
                highlight: chrome.chromeHighlight,
              ),
            ),
          ),
          if (north case final control?)
            Align(alignment: const Alignment(0, -_band), child: control),
          if (south case final control?)
            Align(alignment: const Alignment(0, _band), child: control),
          if (west case final control?)
            Align(alignment: const Alignment(-_band, 0), child: control),
          if (east case final control?)
            Align(alignment: const Alignment(_band, 0), child: control),
          centre,
        ],
      ),
    );
  }
}

class _ClickWheelPainter extends CustomPainter {
  const _ClickWheelPainter({
    required this.face,
    required this.edge,
    required this.well,
    required this.highlight,
  });

  final LinearGradient face;
  final Color edge;
  final Color well;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final centre = bounds.center;
    final radius = size.shortestSide / 2;

    canvas.drawCircle(
      centre,
      radius,
      Paint()..shader = face.createShader(bounds),
    );

    final rim = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStroke.hairline;
    canvas.drawCircle(centre, radius - 0.5, rim);

    // The lit half of the moulding, along the top inside edge.
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius - 2),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = highlight.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final wellRadius = radius * 0.42;
    canvas
      ..drawCircle(centre, wellRadius, Paint()..color = well)
      ..drawCircle(centre, wellRadius, rim);
  }

  @override
  bool shouldRepaint(covariant _ClickWheelPainter oldDelegate) =>
      oldDelegate.face != face ||
      oldDelegate.edge != edge ||
      oldDelegate.well != well ||
      oldDelegate.highlight != highlight;
}
