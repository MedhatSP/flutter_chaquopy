import 'package:flutter/material.dart';
import 'package:chaquopy/chaquopy.dart';

void main() async {
  // Init Chaquopy
  await Chaquopy;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _output = '';

  Future<void> _runPython() async {
    // Get the Python script
    String pythonCode = '''
import sys
sys.stdout.write("Hello from Python!")
''';

    // Run the Python script
    dynamic result = await Chaquopy.executeCode(pythonCode);

    // Update the output
    setState(() {
      _output = result.stdout;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chaquopy Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _runPython,
                child: Text('Run Python'),
              ),
              SizedBox(height: 16),
              Text(_output),
            ],
          ),
        ),
      ),
    );
  }
}
