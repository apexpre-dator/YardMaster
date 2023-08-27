import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(255, 70, 70, .1),
  100: const Color.fromRGBO(255, 70, 70, .2),
  200: const Color.fromRGBO(255, 70, 70, .3),
  300: const Color.fromRGBO(255, 70, 70, .4),
  400: const Color.fromRGBO(255, 70, 70, .5),
  500: const Color.fromRGBO(255, 70, 70, .6),
  600: const Color.fromRGBO(255, 70, 70, .7),
  700: const Color.fromRGBO(255, 70, 70, .8),
  800: const Color.fromRGBO(255, 70, 70, .9),
  900: const Color.fromRGBO(255, 70, 70, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF464667, color);
const canvasColor = Color(0xFF2E2E48);
const darkColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
final lightColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final borderColor = lightColor.withOpacity(0.37);
