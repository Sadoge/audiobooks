import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class EmptyLibraryView extends StatelessWidget {
  const EmptyLibraryView({required this.onImport, super.key});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final minHeight = (MediaQuery.sizeOf(context).height - 214).clamp(
      520.0,
      double.infinity,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _ListeningDoorway(),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'No audiobooks yet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Import audio files from your device to build a library '
                  'that stays with you, even offline.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Import Audiobooks'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListeningDoorway extends StatefulWidget {
  const _ListeningDoorway();

  @override
  State<_ListeningDoorway> createState() => _ListeningDoorwayState();
}

class _ListeningDoorwayState extends State<_ListeningDoorway>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.standard,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.emphasized,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.disableAnimations || mediaQuery.accessibleNavigation) {
      _controller.value = 1;
    } else if (!_controller.isCompleted && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: 'An open listening space waiting for your audiobooks',
      child: ExcludeSemantics(
        child: SizedBox(
          width: 250,
          height: 280,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => CustomPaint(
              painter: _ListeningDoorwayPainter(
                progress: _animation.value,
                panelColor: scheme.surfaceContainerHighest,
                panelEdgeColor: scheme.outlineVariant,
                markerColor: scheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListeningDoorwayPainter extends CustomPainter {
  const _ListeningDoorwayPainter({
    required this.progress,
    required this.panelColor,
    required this.panelEdgeColor,
    required this.markerColor,
  });

  final double progress;
  final Color panelColor;
  final Color panelEdgeColor;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final panelPaint = Paint()..color = panelColor;
    final edgePaint = Paint()
      ..color = panelEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final left = Path()
      ..moveTo(size.width * 0.2, size.height * 0.09)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.04,
        size.width * 0.26,
        size.height * 0.07,
      )
      ..lineTo(size.width * 0.43, size.height * 0.16)
      ..lineTo(size.width * 0.43, size.height * 0.88)
      ..lineTo(size.width * 0.26, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.97,
        size.width * 0.2,
        size.height * 0.91,
      )
      ..close();

    final right = Path()
      ..moveTo(size.width * 0.8, size.height * 0.09)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.04,
        size.width * 0.74,
        size.height * 0.07,
      )
      ..lineTo(size.width * 0.57, size.height * 0.16)
      ..lineTo(size.width * 0.57, size.height * 0.88)
      ..lineTo(size.width * 0.74, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.97,
        size.width * 0.8,
        size.height * 0.91,
      )
      ..close();

    canvas
      ..drawPath(left, panelPaint)
      ..drawPath(left, edgePaint)
      ..drawPath(right, panelPaint)
      ..drawPath(right, edgePaint);

    final markerY = size.height * (0.6 - (0.07 * (1 - progress)));
    final markerPaint = Paint()
      ..color = markerColor.withValues(alpha: progress);
    canvas.drawCircle(Offset(size.width / 2, markerY), 10, markerPaint);
  }

  @override
  bool shouldRepaint(covariant _ListeningDoorwayPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.panelColor != panelColor ||
      oldDelegate.markerColor != markerColor;
}
