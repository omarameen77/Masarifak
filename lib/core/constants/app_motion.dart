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
  static const Duration shimmerDuration = Duration(milliseconds: 1400);
  static const List<double> shimmerStops = [0.35, 0.5, 0.65];
  static const Duration meterFillDuration = Duration(milliseconds: 600);
  static const Curve meterFillCurve = Curves.easeOutCubic;
}
