import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_cp/background_locator.dart';
import 'package:background_locator_cp/location_dto.dart';
import 'package:background_locator_cp/settings/android_settings.dart';
import 'package:background_locator_cp/settings/ios_settings.dart';
import 'package:background_locator_cp/settings/locator_settings.dart';
import 'package:flutter/material.dart';

import 'location_callback_handler.dart';

const String isolateName = 'LocatorIsolate';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ReceivePort port = ReceivePort();

  String logStr = '';
  late bool isRunning;
  late LocationDto? lastLocation;

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(
            isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, isolateName);

    port.listen(
      (dynamic data) async {
        print(data);
      },
    );
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });

    _startLocator();
    print('Running ${isRunning.toString()}');
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter background Locator'),
        ),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(22),
        ),
      ),
    );
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
  }

  Future<void> _startLocator() async{
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: 0,
            stopWithTerminate: true
        ),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }
}
