import 'package:flutter/material.dart';

import '../../core/constants/app_motion.dart';
import 'swipe_back_detector.dart';

class SlideTransitionPage extends Page<void> {
  const SlideTransitionPage({super.key, required this.child});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => _SlideTransitionRoute(this);
}

class _SlideTransitionRoute extends PageRoute<void> {
  _SlideTransitionRoute(SlideTransitionPage page) : super(settings: page);

  SlideTransitionPage get _page => settings as SlideTransitionPage;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => AppMotion.pageSlideDuration;

  @override
  Duration get reverseTransitionDuration => AppMotion.pageSlideReverseDuration;

  bool get _gestureInProgress => navigator?.userGestureInProgress ?? false;

  bool _canStartSwipeBack() =>
      !isFirst &&
      isCurrent &&
      !willHandlePopInternally &&
      !_gestureInProgress &&
      animation?.status == AnimationStatus.completed;

  void _startSwipeBack() => navigator?.didStartUserGesture();

  void _updateSwipeBack(double fraction) {
    final controller = this.controller;
    if (controller == null) return;
    controller.value -= fraction;
  }

  void _endSwipeBack(double velocity) {
    final controller = this.controller;
    final navigator = this.navigator;
    if (controller == null || navigator == null) return;
    final shouldPop = velocity.abs() >= AppMotion.backSwipeFlingVelocity
        ? velocity > 0
        : controller.value < AppMotion.backSwipeCompleteFraction;
    if (shouldPop) {
      navigator.pop();
    } else {
      controller.forward();
    }
    if (!controller.isAnimating) {
      navigator.didStopUserGesture();
      return;
    }
    late final AnimationStatusListener onSettled;
    onSettled = (_) {
      controller.removeStatusListener(onSettled);
      navigator.didStopUserGesture();
    };
    controller.addStatusListener(onSettled);
  }

  Animation<double> _curved(Animation<double> parent) => _gestureInProgress
      ? parent
      : CurvedAnimation(
          parent: parent,
          curve: AppMotion.pageSlideCurve,
          reverseCurve: AppMotion.pageSlideReverseCurve,
        );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => _page.child;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final forward = Offset(isRtl ? -1 : 1, 0);
    final transition = SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: -forward * AppMotion.pageParallaxFraction,
      ).animate(_curved(secondaryAnimation)),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: forward,
          end: Offset.zero,
        ).animate(_curved(animation)),
        child: child,
      ),
    );
    if (Theme.of(context).platform != TargetPlatform.iOS) return transition;
    return SwipeBackDetector(
      canStart: _canStartSwipeBack,
      onStart: _startSwipeBack,
      onUpdate: _updateSwipeBack,
      onEnd: _endSwipeBack,
      child: transition,
    );
  }
}
