import 'package:flutter/animation.dart';

class Tile {
  int x;
  int y;
  int value;

  late Animation<double> animatedX;
  late Animation<double> animatedY;
  late Animation<int> animatedValue;
  late Animation<double> scale;

  void resetAnimations() {
    animatedX = AlwaysStoppedAnimation(x.toDouble());
    animatedY = AlwaysStoppedAnimation(y.toDouble());
    animatedValue = AlwaysStoppedAnimation(value);
    scale = const AlwaysStoppedAnimation(1.0);
  }

  Tile({required this.x, required this.y, required this.value}) {
    resetAnimations();
  }
}