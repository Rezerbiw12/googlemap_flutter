
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RiderMap extends StatefulWidget {
  @override
  _RiderMapState createState() => _RiderMapState();
}

class _RiderMapState extends State<RiderMap> {
  void _showLocationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Locations'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Location 1  Lat.....  Long.....'),
              ),
              SimpleDialogOption(
                child: const Text('Location 2  Lat.....  Long.....'),
              ),
              SimpleDialogOption(
                child: const Text('Location 3  Lat.....  Long.....'),
              ),
            ],
          );
        });
  }

  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(7.8773126, 98.3853486);
  Set<Marker> markers = Set();
  MapType _currentMapType = MapType.normal;
  LatLng centerPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  final Set<Polyline> _polyline = {};
  LatLng _lastMapPosition = _center;
  List<LatLng> latlng = List();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onAddMarkerButtonPressed() {
    InfoWindow infoWindow =
        InfoWindow(title: "Location" + markers.length.toString());
    Marker marker = Marker(
      markerId: MarkerId(markers.length.toString()),
      infoWindow: infoWindow,
      position: centerPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    setState(() {
      markers.add(marker);
    });
    _polyline.add(Polyline(
      polylineId: PolylineId(_lastMapPosition.toString()),
      visible: true,
      //latlng is List<LatLng>  
      points: latlng,
      color: Colors.blue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          "Google Map",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            polylines:_polyline,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: _currentMapType,
            markers: markers,
            onCameraMove: _onCameraMove,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: new FloatingActionButton(
                heroTag: "btn1",
                onPressed: _showLocationDialog,
                child: new Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: new FloatingActionButton(
                heroTag: "btn2",
                onPressed: _onAddMarkerButtonPressed,
                child: new Icon(
                  Icons.edit_location,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.person_pin_circle, size: 40.0),
          )
        ],
      ),
    ));
  }

  void _onCameraMove(CameraPosition position) {
    Icon(Icons.map);
    centerPosition = position.target;
  }
}
