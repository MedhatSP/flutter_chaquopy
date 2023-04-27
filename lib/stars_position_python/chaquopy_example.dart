import 'package:flutter/material.dart';

import 'package:chaquopy/chaquopy.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String pycode = '''
from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body, get_moon
from astropy.coordinates import SkyCoord, EarthLocation, AltAz
from astropy import units as u

# Set the time and location of the observer
t = Time("2023-04-16 17:20:00", scale="utc") # Cairo time
loc = EarthLocation(lat=30.0444*u.deg, lon=31.2357*u.deg) # Cairo

# Set the solar system ephemeris to DE432s
solar_system_ephemeris.set('de432s')

# Get the positions of the planets
planets = ["mercury", "venus", "mars", "jupiter", "saturn", "uranus", "neptune"]
positions = {}
for planet in planets:
    positions[planet] = get_body(planet, t, loc)

# Convert to AltAz frame
altaz_frame = AltAz(obstime=t, location=loc)
altaz_positions = {}
for planet in positions:
    altaz_positions[planet] = positions[planet].transform_to(altaz_frame)
    
# Print the results
for planet in planets:
    print(f"{planet.title()}:")
    print(f"Altitude: {altaz_positions[planet].alt:.5f}")
    print(f"Azimuth: {altaz_positions[planet].az:.5f}")
    print(f"Right Ascension: {positions[planet].ra:.5f}")
    print(f"Declination: {positions[planet].dec:.5f}")
    print()''';
  String _outputOrError = "";

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/PlanetsPositionPY copy.txt');
  }
  // Future<String> getFileData(String path) async {
  //   return await rootBundle.loadString(path);
  // }

  Map<String, dynamic> data = Map();
  bool loadImageVisibility = true;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void addIntendation() {
    TextEditingController _updatedController = TextEditingController();

    int currentPosition = _controller.selection.start;

    String controllerText = _controller.text;
    String text = controllerText.substring(0, currentPosition) +
        "    " +
        controllerText.substring(currentPosition, controllerText.length);

    _updatedController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _controller.text.length + 4,
        extentOffset: _controller.text.length + 4,
      ),
    );

    setState(() {
      _controller = _updatedController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 4),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  controller: _controller,
                  minLines: 10,
                  maxLines: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    'This shows Output Or Error : $_outputOrError',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () => addIntendation(),
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        height: 50,
                        color: Colors.green,
                        child: Text(
                          'run Code',
                        ),
                        onPressed: () async {
                          // to run PythonCode, just use executeCode function, which will return map with following format
                          // {
                          // "textOutputOrError" : output of the code / error generated while running the code
                          // }
                          String code = await loadAsset(context);
                          final _result = await Chaquopy.executeCode(code);
                          setState(() {
                            _outputOrError = _result['textOutputOrError'] ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
