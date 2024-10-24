import 'dart:math';
import 'package:flutter/material.dart';

class Fish {
  final Color color;
  double speed;
  double xPos;
  double yPos;
  late double xVelocity;
  late double yVelocity;
  int? id;

  Fish({
    required this.color,
    required this.speed,
    this.xPos = 150,
    this.yPos = 150,
    this.id,
  }) {
    final random = Random();
    xVelocity = (random.nextDouble() * 2 - 1) * speed; 
    yVelocity = (random.nextDouble() * 2 - 1) * speed;
  }

  void updatePosition() {
    xPos += xVelocity;
    yPos += yVelocity;

    if (xPos <= 0 || xPos >= 300 - 30) {
      xVelocity = -xVelocity;
    }

    if (yPos <= 0 || yPos >= 300 - 30) {
      yVelocity = -yVelocity;
    }
  }

  Widget buildFish() {
    return Positioned(
      left: xPos,
      top: yPos,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
