import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  getLocation({LatLng location}) async {
    var head = "https://maps.googleapis.com/maps/api/geocode/json?latlng=";
    var lat = "${location.latitude}";
    var comma = ",";
    var long = "${location.longitude}";
    var key = "&key=AIzaSyAIBSRxCOHKfzMqh5QV8Er6_tRYNFTudTE";
    var url = head + lat + comma + long + key;
    var res = await http.get(url);
    var map = json.decode(utf8.decode(res.bodyBytes));
    print("${map['results'][0]['address_components'][1]['long_name']}");
    setState(() {
      data = map['results'][0];
    });
  }

  LatLng first_location; //= LatLng(7.8773126, 98.3853486);
  LatLng final_location; //= LatLng(7.8761, 98.3794);
  var data;
  double sticky = 0.0;
  bool isloading = false;
  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  LatLng centerPosition;
  //Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Set<Polyline> _polylines = {};
  //LatLng _lastMapPosition;
  bool onsearch = false;
  bool yourlocation = true;
  AnimationController _controllers;
  AnimationController _controllerb;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> latlng = List();
  // LatLng _new = LatLng(7.8773126, 98.3853486);
  // LatLng _news = LatLng(7.8796, 98.3814);

  String googleAPIKey = "AIzaSyAIBSRxCOHKfzMqh5QV8Er6_tRYNFTudTE";

  getUserLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getUserLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 20,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //setMapPins();
    //setPolylines();
  }

  void _onAddMarkerButtonPressed() {
    InfoWindow infoWindow = InfoWindow(
        title: data['address_components'][1]['long_name'],
        snippet: data['formatted_address']);
    Marker markers = Marker(
      markerId: MarkerId(_markers.length.toString()),
      infoWindow: infoWindow,
      position: centerPosition,
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    setState(() {
      _markers.add(markers);
      if (_markers.length==2)
      setPolylines();
      else
      _markers.add(markers);

      print('marker : ${_markers.length}');
      // latlng.add(_new);
      // latlng.add(_news);
    });
    // _polylines.add(Polyline(
    //   polylineId: PolylineId(_center.toString()),
    //   visible: true,
    //   //latlng is List<LatLng>
    //   points: latlng,
    //   color: Colors.redAccent,
    // ));
  }

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        _markers.elementAt(0).position.latitude,
        _markers.elementAt(0).position.longitude,
        _markers.elementAt(1).position.latitude,
        _markers.elementAt(1).position.longitude);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      print('first:   ${_markers.elementAt(0).position.longitude}');
      print('fional:  ${_markers.elementAt(1).position.longitude}');
      Polyline polyline = Polyline(
          width: 5,
          polylineId: PolylineId('poly'),
          color: Colors.blueAccent,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  _onCameraMove(CameraPosition position) {
    Icon(Icons.map);
    centerPosition = position.target;
    print(centerPosition.latitude);
    print(centerPosition.longitude);
  }

  @override
  void initState() {
    getLocation();
    print('สร้าง map');
    _controllerb = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 2),
    )..repeat();
    _center = LatLng(7.8773126, 98.3853486);
    //_lastMapPosition = _center;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'การเดินทาง',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.near_me,
                color: Colors.black,
              ),
              onPressed: _goToMe)
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (latlng) {},
            onCameraIdle: () async {
              setState(() {
                sticky = 0;
                onsearch = true;
              });
              //getaddress(context,centerPosition.latitude,centerPosition.longitude);
              await Future.delayed(Duration(seconds: 2)); //ตอน get data
              setState(() {
                onsearch = false;
                getLocation(location: centerPosition);
              });
            },
            onCameraMoveStarted: () {
              setState(() {
                sticky = 6;
                onsearch = false;
                yourlocation = false;
              });
              if (yourlocation == false) {
                _controllers.reset();
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            polylines: _polylines,
            onMapCreated: _onMapCreated,
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -8 - sticky),
              child: Container(
                height: 20,
                width: 5,
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
            child: onsearch
                ? AnimatedBuilder(
                    animation: CurvedAnimation(
                        parent: _controllerb, curve: Curves.fastOutSlowIn),
                    builder: (BuildContext context, Widget child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          _buildContainer(50 * _controllerb.value),
                          _buildContainer(100 * _controllerb.value),
                          _buildContainer(150 * _controllerb.value),
                          // _buildContainer(200 * _controllerb.value),
                          // _buildContainer(250 * _controllerb.value),
                        ],
                      );
                    },
                  )
                : Container(),
          ),
          Center(
              child: GestureDetector(
            onTap: _onAddMarkerButtonPressed,
            child: Transform.translate(
              offset: Offset(0, -30 - sticky),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      //กรณี่เลื่อนหน้าจอ จะทำการแสดงการหมุน
                      child: onsearch
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
            ),
          )),
          Center(
            child: Transform.translate(
              offset: Offset(0, 3),
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
                                      hintText: data == null
                                          ? '     กำลังหนาตำแหน่งของคุณ'
                                          : '    ${data['formatted_address']}' //bug
                                      ),
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

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent.withOpacity(1 - _controllerb.value),
      ),
    );
  }
}
