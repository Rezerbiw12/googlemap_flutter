import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double sticky = 0.0;
  bool isloading = false;
  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  Set<Marker> markers = Set();
  MapType _currentMapType = MapType.normal;
  LatLng centerPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  final Set<Polyline> _polyline = {};
  LatLng _lastMapPosition;
  List<LatLng> latlng = List();
  bool onsearch = false;
  bool yourlocation = true;
  AnimationController _controllers;

  getUserLocation() {
    var location = Location();
    try {
      location.onLocationChanged().listen((LocationData currentLocation) {
        final center =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        _center = center;
        //getaddress(context,_center.latitude,_center.longitude);
        setState(() {
          isloading = true;
        });
      });
    } on Exception {
      return null;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    Icon(Icons.map);
    centerPosition = position.target;
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
  void initState() {
    print('xxxxxxx');
    _center = LatLng(7.8773126, 98.3853486);
    _lastMapPosition = _center;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onCameraIdle: () {
              sticky = 0;
              //getaddress(context,centerPosition.latitude,centerPosition.longitude);
            },
            onCameraMoveStarted: () {
              sticky = 10;
              onsearch = true;
              yourlocation = false;
              if (yourlocation == false) {
                _controllers.reset();
              }
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            polylines: _polyline,
            onMapCreated: _onMapCreated,
            mapType: _currentMapType,
            markers: markers,
            onCameraMove: _onCameraMove,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, 5 - sticky),
              child: Container(
                height: 20,
                width: 3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -25 - sticky),
              child: Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                        child: onsearch
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : null)
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, 5),
              child: Container(
                width: 10,
                height: 2,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                  ),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                            height: 120,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15, top: 15),
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        'https://download.seaicons.com/icons/danieledesantis/playstation-flat/512/playstation-circle-black-and-white-icon.png',
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15, top: 43),
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        'https://freesvg.org/img/flat_location_logo.png',
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            height: 120,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '    Enter a search term'),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 20.0),
                                            child: Divider(
                                              color: Colors.black,
                                            ))),
                                  ],
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '    ฉันกำลังจะไป...'),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
