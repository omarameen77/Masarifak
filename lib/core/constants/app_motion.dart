import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const Duration pageSlideDuration = Duration(milliseconds: 420);
  static const Duration pageSlideReverseDuration = Duration(milliseconds: 360);
  static const Curve pageSlideCurve = Curves.easeOutCubic;
  static const Curve pageSlideReverseCurve = Curves.easeInCubic;
  static const double pageParallaxFraction = 0.3;
  static const double backSwipeEdgeWidth = 20;
  static const double backSwipeFlingVelocity = 1;
  static const double backSwipeCompleteFraction = 0.5;
}
