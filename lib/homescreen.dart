import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/mapPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  LocationData currentLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MaterialButton(
          child: Text('data'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MapPage(),
            ),
          ),
        ),
      ),
    );
  }
}
