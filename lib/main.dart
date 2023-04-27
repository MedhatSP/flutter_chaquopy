import 'package:flutter/material.dart';
import 'package:test_ai_solution_for_ds_1/planets_position_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Planet Positions')),
        body: Center(
          child: FutureBuilder<String>(
            future: PlanetsPositionPlugin.getPlanetPositions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Positions: ${snapshot.data}');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
