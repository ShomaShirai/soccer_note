import 'package:flutter/material.dart';

class Player {
  String name;
  Color color;
  Offset position;

  Player({required this.name, this.color = Colors.red, required this.position});
}