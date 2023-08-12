import 'package:flutter/material.dart';

class CustomIcon {
  CustomIcon._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData cogalt =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData videocam =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData folderOpen =
      IconData(0xf07c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sortAmountDown =
      IconData(0xf160, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData history =
      IconData(0xf1da, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData connectdevelop =
      IconData(0xf20e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData userSecret =
      IconData(0xf21b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

List<Shadow> shadowValue = [
  const Shadow(
      color: (Color.fromARGB(255 ~/ 4, 0, 0, 0)),
      blurRadius: 8.0,
      offset: Offset(0, 3))
];
List<Shadow> listtileTitleShadowValue = [
  const Shadow(
      color: (Color.fromARGB(255 ~/ 4, 0, 0, 0)),
      blurRadius: 8.0,
      offset: Offset(0, 3))
];
TextStyle listTileTitleText =
    const TextStyle(color: Color.fromARGB(210, 54, 78, 90), fontSize: 18);
const TextStyle listTileSubTitleText =
    TextStyle(color: Color.fromARGB(167, 47, 69, 80));
