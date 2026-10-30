import 'package:flutter/widgets.dart';

import '../../core/constants/app_motion.dart';

class SwipeBackDetector extends StatefulWidget {
  const SwipeBackDetector({
    super.key,
    required this.canStart,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.child,
  });

  final bool Function() canStart;
  final VoidCallback onStart;
  final ValueChanged<double> onUpdate;
  final ValueChanged<double> onEnd;
  final Widget child;

  @override
  State<SwipeBackDetector> createState() => _SwipeBackDetectorState();
}

class _SwipeBackDetectorState extends State<SwipeBackDetector> {
  bool _active = false;

  double get _backSign =>
      Directionality.of(context) == TextDirection.rtl ? -1 : 1;

  double get _width => context.size?.width ?? 1;

  void _start(DragStartDetails details) {
    if (!widget.canStart()) return;
    _active = true;
    widget.onStart();
  }

  void _update(DragUpdateDetails details) {
    if (!_active) return;
    widget.onUpdate((details.primaryDelta ?? 0) / _width * _backSign);
  }

  void _end(DragEndDetails details) {
    if (!_active) return;
    _active = false;
    widget.onEnd(details.velocity.pixelsPerSecond.dx / _width * _backSign);
  }

  void _cancel() {
    if (!_active) return;
    _active = false;
    widget.onEnd(0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        PositionedDirectional(
          start: 0,
          top: 0,
          bottom: 0,
          width: AppMotion.backSwipeEdgeWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _start,
            onHorizontalDragUpdate: _update,
            onHorizontalDragEnd: _end,
            onHorizontalDragCancel: _cancel,
          ),
        ),
      ],
    );
  }
}
