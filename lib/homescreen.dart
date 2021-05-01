import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/hotelscreen.dart';
import 'package:ui_test/mapPage.dart';
import 'package:ui_test/widget/AlertDialog.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState> _batteryStateSubscription;
  AudioCache audioCache = AudioCache();
  AudioPlayer player;
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  LocationData currentLocation;

  sendNotification(String title, String description) async {
    //  print('ใช้เสียง' + sound);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '10000',
      'FLUTTER_NOTIFICATION_CHANNEL',
      'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      111,
      title,
      description,
      platformChannelSpecifics,
    );
  }

  void _playFile() async {
    player = await audioCache.play('alert_signal.mp3',
        isNotification: true); // assign player here
  }

  void _stopFile() {
    player?.stop(); // stop the file like this
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          _connectionStatus = result.toString();
          print('wifi');
          print('กำลังออนไลน์');
          sendNotification(
            'การเชื่ิอมต่อ',
            'กำลังเข้าสู่โหมดออนไลน์',
          );
        });

        break;
      case ConnectivityResult.mobile:
        setState(() {
          _connectionStatus = result.toString();
          print('mobile');
          print('กำลังออนไลน์');
          sendNotification(
            'การเชื่ิอมต่อ',
            'กำลังเข้าสู่โหมดออนไลน์',
          );
        });

        break;
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
          print('offline');
          print('กำลังออฟไลน์');
          _playFile();
          showDiaglogs('แจ้งเตือน', 'อุปกรณ์ของคุณขาดการเชื่อมต่ออินเตอร์เน็ต',
              _stopFile, context);
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  void initState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {});
    });
    var initializationSettingsAndroid =
        AndroidInitializationSettings('newlogo');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      print("onSelectNotification called.");
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF696D77), Color(0xFF292C36)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.white,
                child: Text('Google Map'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MapPage(),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.white,
                child: Text('Hotel Screen'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HotelScreen(),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.battery_unknown),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('Battery Check'),
                    ),
                  ],
                ),
                onPressed: () async {
                  final int batteryLevel = await _battery.batteryLevel;
                  showDiaglogs('แบตเตอร์รี่ต่ำ', '$batteryLevel% ที่เหลืออยู่',
                      _stopFile, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
