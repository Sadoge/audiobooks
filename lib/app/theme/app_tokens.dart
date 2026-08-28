import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract final class AppRadii {
  static const BorderRadius control = BorderRadius.all(Radius.circular(14));
  static const BorderRadius cover = BorderRadius.all(Radius.circular(12));
}

abstract final class AppMotion {
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 280);
  static const Curve emphasized = Curves.easeOutCubic;
}

abstract final class AppIconSize {
  static const double small = 20;
  static const double regular = 24;
  static const double large = 32;
}
