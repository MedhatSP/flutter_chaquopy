import 'dart:async';

import 'package:flutter/services.dart';

class PlanetsPositionPlugin {
  static const MethodChannel _channel =
      const MethodChannel('planets_position_plugin');

  static Future<String> getPlanetPositions() async {
    final String result = await _channel.invokeMethod('getPlanetPositions');
    return result;
  }
}
