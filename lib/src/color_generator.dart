import 'package:flutter/material.dart';
import "dart:math";

class ColorGenerator {
  ColorGenerator._();

  static Color generateColor({int? seed}) {
    Random random = Random(seed);
    return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256)
      );
  }

  static List<Color> generateColors(int number, {int? seed}) {
    Random random = Random(seed);
    List<Color> colors = <Color>[];
    for (int i = 0; i < number; i++) {
      colors.add(Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256)
      ));
    }
    return colors;
  }
}