import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_cp/location_dto.dart';

import 'main.dart';



@pragma('vm:entry-point')
class LocationCallbackHandler {

  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {

  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {

  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send("Aiai amor");
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}
