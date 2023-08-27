import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(255, 70, 70, .1),
  100: Color.fromRGBO(255, 70, 70, .2),
  200: Color.fromRGBO(255, 70, 70, .3),
  300: Color.fromRGBO(255, 70, 70, .4),
  400: Color.fromRGBO(255, 70, 70, .5),
  500: Color.fromRGBO(255, 70, 70, .6),
  600: Color.fromRGBO(255, 70, 70, .7),
  700: Color.fromRGBO(255, 70, 70, .8),
  800: Color.fromRGBO(255, 70, 70, .9),
  900: Color.fromRGBO(255, 70, 70, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF464667, color);
const canvasColor = Color(0xFF2E2E48);
const darkColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
final lightColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final borderColor = lightColor.withOpacity(0.37);
