import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
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
                const _PocketPlayer(),
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

/// The empty-state mark: a pocket player with a blank screen, waiting to be
/// loaded. Its centre key lights up as the screen settles.
class _PocketPlayer extends StatefulWidget {
  const _PocketPlayer();

  @override
  State<_PocketPlayer> createState() => _PocketPlayerState();
}

class _PocketPlayerState extends State<_PocketPlayer>
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
    final chrome = RetroChrome.of(context);
    return Semantics(
      image: true,
      label: 'A pocket player waiting for your audiobooks',
      child: ExcludeSemantics(
        child: SizedBox(
          width: 250,
          height: 280,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => CustomPaint(
              painter: _PocketPlayerPainter(
                progress: _animation.value,
                chrome: chrome,
                markerColor: scheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PocketPlayerPainter extends CustomPainter {
  const _PocketPlayerPainter({
    required this.progress,
    required this.chrome,
    required this.markerColor,
  });

  final double progress;
  final RetroChrome chrome;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final edge = Paint()
      ..color = chrome.chromeEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStroke.hairline;

    // The housing.
    final body = RRect.fromLTRBR(
      size.width * 0.184,
      size.height * 0.029,
      size.width * 0.816,
      size.height * 0.971,
      const Radius.circular(16),
    );
    canvas
      ..drawRRect(
        body,
        Paint()..shader = chrome.chrome.createShader(body.outerRect),
      )
      ..drawRRect(body, edge);

    // The blank screen, with two dim rules where a menu would be.
    final screen = RRect.fromLTRBR(
      size.width * 0.248,
      size.height * 0.107,
      size.width * 0.752,
      size.height * 0.45,
      const Radius.circular(AppRadii.screenUnit),
    );
    canvas
      ..drawRRect(screen, Paint()..color = chrome.screenFill)
      ..drawRRect(
        screen,
        Paint()
          ..color = chrome.screenEdge
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppStroke.hairline,
      );

    final rule = Paint()
      ..color = chrome.screenInkDim.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var row = 0; row < 2; row++) {
      final y = size.height * (0.19 + (row * 0.075));
      canvas.drawLine(
        Offset(size.width * 0.3, y),
        Offset(size.width * (row.isEven ? 0.63 : 0.55), y),
        rule,
      );
    }

    // The wheel.
    final wheelCentre = Offset(size.width / 2, size.height * 0.7);
    const wheelRadius = 54.0;
    final wheelBounds = Rect.fromCircle(
      center: wheelCentre,
      radius: wheelRadius,
    );
    canvas
      ..drawCircle(
        wheelCentre,
        wheelRadius,
        Paint()..shader = chrome.wheel.createShader(wheelBounds),
      )
      ..drawCircle(wheelCentre, wheelRadius, edge);

    // The centre key lights and settles into its well.
    final settle = 6 * (1 - progress);
    canvas
      ..drawCircle(wheelCentre, 21, Paint()..color = chrome.wheelWell)
      ..drawCircle(
        wheelCentre.translate(0, -settle),
        21,
        Paint()..color = markerColor.withValues(alpha: progress),
      );
  }

  @override
  bool shouldRepaint(covariant _PocketPlayerPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.chrome != chrome ||
      oldDelegate.markerColor != markerColor;
}
