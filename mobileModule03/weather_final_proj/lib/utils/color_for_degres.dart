import 'package:flutter/material.dart';

Color getColorForTemperature(double temperature) {
  const double minTemperature = 10;
  const double maxTemperature = 30;

  const Color coldColor = Colors.blue;
  const Color hotColor = Colors.red;

  double normalizedTemperature = (temperature - minTemperature) / (maxTemperature - minTemperature);

  return Color.lerp(coldColor, hotColor, normalizedTemperature) ?? Colors.transparent;
}
