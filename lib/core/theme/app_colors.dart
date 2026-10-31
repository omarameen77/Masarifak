import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.sunk,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.line,
    required this.line2,
    required this.acc,
    required this.accInk,
    required this.accSoft,
    required this.accText,
    required this.warn,
    required this.warnSoft,
    required this.warnLine,
    required this.crit,
    required this.critSoft,
    required this.critLine,
    required this.lux,
    required this.scrim,
    required this.shadow,
    required this.dangerInk,
  });

  final Color bg;
  final Color surface;
  final Color sunk;
  final Color ink;
  final Color ink2;
  final Color muted;
  final Color line;
  final Color line2;
  final Color acc;
  final Color accInk;
  final Color accSoft;
  final Color accText;
  final Color warn;
  final Color warnSoft;
  final Color warnLine;
  final Color crit;
  final Color critSoft;
  final Color critLine;
  final Color lux;
  final Color scrim;
  final Color shadow;
  final Color dangerInk;

  static const light = AppColors(
    bg: Color(0xFFF7F6F2),
    surface: Color(0xFFFFFFFF),
    sunk: Color(0xFFEFEDE7),
    ink: Color(0xFF252923),
    ink2: Color(0xFF4A4E47),
    muted: Color(0xFF6E716A),
    line: Color(0xFFE6E4DD),
    line2: Color(0xFFD6D3CA),
    acc: Color(0xFF426B56),
    accInk: Color(0xFFFFFFFF),
    accSoft: Color(0xFFE6EEE9),
    accText: Color(0xFF355846),
    warn: Color(0xFF8A5A0B),
    warnSoft: Color(0xFFF7ECD8),
    warnLine: Color(0xFFE9D3A8),
    crit: Color(0xFFA23E33),
    critSoft: Color(0xFFF7E3DF),
    critLine: Color(0xFFEBC4BD),
    lux: Color(0xFF8A5A0B),
    scrim: Color.fromRGBO(20, 22, 19, .42),
    shadow: Color.fromRGBO(37, 41, 35, 1),
    dangerInk: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    bg: Color(0xFF161916),
    surface: Color(0xFF1F231F),
    sunk: Color(0xFF262B26),
    ink: Color(0xFFECEDE8),
    ink2: Color(0xFFC9CBC4),
    muted: Color(0xFFA0A39B),
    line: Color(0xFF2E332E),
    line2: Color(0xFF3A403A),
    acc: Color(0xFF7DAA90),
    accInk: Color(0xFF102016),
    accSoft: Color(0xFF22322A),
    accText: Color(0xFF9CC4AD),
    warn: Color(0xFFE2B566),
    warnSoft: Color(0xFF352B19),
    warnLine: Color(0xFF56442A),
    crit: Color(0xFFEE9A8E),
    critSoft: Color(0xFF3A2321),
    critLine: Color(0xFF5A3530),
    lux: Color(0xFFE2B566),
    scrim: Color.fromRGBO(20, 22, 19, .42),
    shadow: Color.fromRGBO(37, 41, 35, 1),
    dangerInk: Color(0xFF1B0F0D),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? sunk,
    Color? ink,
    Color? ink2,
    Color? muted,
    Color? line,
    Color? line2,
    Color? acc,
    Color? accInk,
    Color? accSoft,
    Color? accText,
    Color? warn,
    Color? warnSoft,
    Color? warnLine,
    Color? crit,
    Color? critSoft,
    Color? critLine,
    Color? lux,
    Color? scrim,
    Color? shadow,
    Color? dangerInk,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      sunk: sunk ?? this.sunk,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      line2: line2 ?? this.line2,
      acc: acc ?? this.acc,
      accInk: accInk ?? this.accInk,
      accSoft: accSoft ?? this.accSoft,
      accText: accText ?? this.accText,
      warn: warn ?? this.warn,
      warnSoft: warnSoft ?? this.warnSoft,
      warnLine: warnLine ?? this.warnLine,
      crit: crit ?? this.crit,
      critSoft: critSoft ?? this.critSoft,
      critLine: critLine ?? this.critLine,
      lux: lux ?? this.lux,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
      dangerInk: dangerInk ?? this.dangerInk,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      sunk: Color.lerp(sunk, other.sunk, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      line2: Color.lerp(line2, other.line2, t)!,
      acc: Color.lerp(acc, other.acc, t)!,
      accInk: Color.lerp(accInk, other.accInk, t)!,
      accSoft: Color.lerp(accSoft, other.accSoft, t)!,
      accText: Color.lerp(accText, other.accText, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      warnSoft: Color.lerp(warnSoft, other.warnSoft, t)!,
      warnLine: Color.lerp(warnLine, other.warnLine, t)!,
      crit: Color.lerp(crit, other.crit, t)!,
      critSoft: Color.lerp(critSoft, other.critSoft, t)!,
      critLine: Color.lerp(critLine, other.critLine, t)!,
      lux: Color.lerp(lux, other.lux, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      dangerInk: Color.lerp(dangerInk, other.dangerInk, t)!,
    );
  }
}
