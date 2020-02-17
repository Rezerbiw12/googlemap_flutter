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
  var check = 1;
  LatLng first_location;
  LatLng final_location;
  var data;
  var data2;
  bool mylocation = false;
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

  String googleAPIKey = "AIzaSyAIBSRxCOHKfzMqh5QV8Er6_tRYNFTudTE";

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
    if (check == 1) {
      setState(() {
        data = map['results'][0];
      });
    } else {
      setState(() {
        data2 = map['results'][0];
      });
    }
  }

  getUserLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      return null;
    }
  }

  _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getUserLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 16,
        ),
      ),
    );
    setState(() {
      mylocation = true;
      print('go_to_me :${mylocation.toString()}');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onAddMarkerButtonPressed() {
    InfoWindow infoWindow = InfoWindow(
        title: data['address_components'][1]['long_name'],
        snippet: data['formatted_address']);
    Marker markers = Marker(
      markerId: MarkerId(_markers.length.toString()),
      infoWindow: infoWindow,
      position: centerPosition,
    );
    setState(() {
      _markers.add(markers);
      if (_markers.length == 2) {
        setPolylines();
      } else {
        _polylines.clear();
        _markers.clear();
        setPolylines();
        _markers.add(markers);
        check = 2;
      }
      print('polyline: ${_polylines.length}');
      print('marker :${_markers.length}');
    });
  }

  setPolylines() async {
    _polylines.clear();
    print('marker:${_markers.toString()}');
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        _markers.elementAt(0).position.latitude,
        _markers.elementAt(0).position.longitude,
        _markers.elementAt(1).position.latitude,
        _markers.elementAt(1).position.longitude);
    print('result:......${result.toString()}');
    // if (result.isNotEmpty) {
    result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    // }
    print('result 2 :......${result.length}');
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
    result.clear();
  }

  _onCameraMove(CameraPosition position) {
    Icon(Icons.map);
    centerPosition = position.target;
  }

  showdata() {
    print('----------${_onAddMarkerButtonPressed}');
  }

  @override
  void initState() {
    getLocation();
    _goToMe();
    print('สร้าง map');
    _controllerb = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 2),
    )..repeat();
    _center = LatLng(7.8776, 98.3855);
    //_lastMapPosition = _center;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: _goToMe)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onCameraIdle: () async {
                setState(() {
                  sticky = 0;
                  onsearch = true;
                  showdata();
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
                  mylocation = false;
                  sticky = 6;
                  onsearch = false;
                  yourlocation = false;
                  print('camera_move_start : ${mylocation.toString()}');
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
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
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
                                parent: _controllerb,
                                curve: Curves.fastOutSlowIn),
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
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child:
                    (mylocation == true) 
                        ? null
                        : Container(
                            child: GestureDetector(
                                onTap: _goToMe,
                                child: new Container(
                                  height: 35.0,
                                  width: 35.0,
                                  child: Center(
                                    child: Image.network(
                                        'https://cdn3.iconfinder.com/data/icons/mobile-friendly-ui/100/crosshair-512.png'),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                        offset: Offset(5.0, 5.0),
                                      )
                                    ],
                                  ),
                                )),
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
                                      hintText: data == null ||
                                              (onsearch && check == 1)
                                          ? '     กำลังหาตำแหน่งของคุณ'
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
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: data2 == null ||
                                                (onsearch && check == 2)
                                            ? '     ฉันกำลังไป'
                                            : '    ${data2['formatted_address']}'))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
