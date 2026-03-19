import 'package:flutter/material.dart';

class GruvboxColors {
  // Light
  static const lightBg = Color(0xFFFBF1C7);
  static const lightBgAlt = Color(0xFFF2E5BC);
  static const lightSurface = Color(0xFFEBDBB2);
  static const lightSurfaceHover = Color(0xFFD5C4A1);
  static const lightSurfaceActive = Color(0xFFBDAE93);

  static const lightAccent = Color(0xFF3C3836);
  static const lightAccentBright = Color(0xFF504945);
  static const lightAccentSoft = Color(0x0F3C3836);
  static const lightAccentBorder = Color(0x263C3836);

  static const lightBorder = Color(0xFFD5C4A1);
  static const lightBorderHeavy = Color(0xFFBDAE93);

  static const lightText = Color(0xFF3C3836);
  static const lightTextSecondary = Color(0xFF665C54);
  static const lightTextDim = Color(0xFF928374);
  static const lightTextOnAccent = Color(0xFFFBF1C7);

  // Dark
  static const darkBg = Color(0xFF282828);
  static const darkBgAlt = Color(0xFF1D2021);
  static const darkSurface = Color(0xFF3C3836);
  static const darkSurfaceHover = Color(0xFF504945);
  static const darkSurfaceActive = Color(0xFF665C54);

  static const darkAccent = Color(0xFF689D6A);
  static const darkAccentBright = Color(0xFF8EC07C);
  static const darkAccentSoft = Color(0x1A689D6A);
  static const darkAccentBorder = Color(0x338EC07C);

  static const darkBorder = Color(0xFF3C3836);
  static const darkBorderHeavy = Color(0xFF504945);

  static const darkText = Color(0xFFEBDBB2);
  static const darkTextSecondary = Color(0xFFBDAE93);
  static const darkTextDim = Color(0xFF928374);
  static const darkTextOnAccent = Color(0xFF282828);
}

class GruvboxTheme {
  final bool isDark;

  const GruvboxTheme({required this.isDark});

  Color get bg => isDark ? GruvboxColors.darkBg : GruvboxColors.lightBg;
  Color get bgAlt => isDark ? GruvboxColors.darkBgAlt : GruvboxColors.lightBgAlt;
  Color get surface => isDark ? GruvboxColors.darkSurface : GruvboxColors.lightSurface;
  Color get surfaceHover => isDark ? GruvboxColors.darkSurfaceHover : GruvboxColors.lightSurfaceHover;
  Color get surfaceActive => isDark ? GruvboxColors.darkSurfaceActive : GruvboxColors.lightSurfaceActive;

  Color get accent => isDark ? GruvboxColors.darkAccent : GruvboxColors.lightAccent;
  Color get accentBright => isDark ? GruvboxColors.darkAccentBright : GruvboxColors.lightAccentBright;
  Color get accentSoft => isDark ? GruvboxColors.darkAccentSoft : GruvboxColors.lightAccentSoft;
  Color get accentBorder => isDark ? GruvboxColors.darkAccentBorder : GruvboxColors.lightAccentBorder;

  Color get border => isDark ? GruvboxColors.darkBorder : GruvboxColors.lightBorder;
  Color get borderHeavy => isDark ? GruvboxColors.darkBorderHeavy : GruvboxColors.lightBorderHeavy;

  Color get text => isDark ? GruvboxColors.darkText : GruvboxColors.lightText;
  Color get textSecondary => isDark ? GruvboxColors.darkTextSecondary : GruvboxColors.lightTextSecondary;
  Color get textDim => isDark ? GruvboxColors.darkTextDim : GruvboxColors.lightTextDim;
  Color get textOnAccent => isDark ? GruvboxColors.darkTextOnAccent : GruvboxColors.lightTextOnAccent;
}
