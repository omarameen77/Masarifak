import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child, this.semanticLabel});

  final Widget child;
  final String? semanticLabel;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmerDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            child: widget.child,
            builder: (context, child) => ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => LinearGradient(
                colors: [colors.sunk, colors.surface, colors.sunk],
                stops: AppMotion.shimmerStops,
                transform: _SlidingGradient(
                  isRtl ? 1 - _controller.value : _controller.value,
                ),
              ).createShader(bounds),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradient extends GradientTransform {
  const _SlidingGradient(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (progress * 2 - 1), 0, 0);
}
