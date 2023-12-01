import 'dart:io';
import 'dart:ui';

import 'package:background_locator_cp/keys.dart';
import 'package:background_locator_cp/location_dto.dart';
import 'package:background_locator_cp/settings/android_settings.dart';
import 'package:background_locator_cp/settings/ios_settings.dart';

class SettingsUtil {
  static Map<String, dynamic> getArgumentsMap(
      {required void Function(LocationDto) callback,
      void Function(Map<String, dynamic>)? initCallback,
      Map<String, dynamic>? initDataCallback,
        required void Function(bool) gpsCallBack,
      void Function()? disposeCallback,
      AndroidSettings androidSettings = const AndroidSettings(),
      IOSSettings iosSettings = const IOSSettings()}) {
    final args = _getCommonArgumentsMap(callback: callback,
        gpsCallBack: gpsCallBack,
        initCallback: initCallback,
        initDataCallback: initDataCallback,
        disposeCallback: disposeCallback);

    if (Platform.isAndroid) {
      args.addAll(_getAndroidArgumentsMap(androidSettings));
    } else if (Platform.isIOS) {
      args.addAll(_getIOSArgumentsMap(iosSettings));
    }

    return args;
  }

  static Map<String, dynamic> _getCommonArgumentsMap({
    required void Function(LocationDto) callback,
    void Function(Map<String, dynamic>)? initCallback,
    Map<String, dynamic>? initDataCallback,
     required void Function(bool)? gpsCallBack,
    void Function()? disposeCallback
  }) {
    final Map<String, dynamic> args = {
      Keys.ARG_CALLBACK:
          PluginUtilities.getCallbackHandle(callback)!.toRawHandle(),
    };

    if (initCallback != null) {
      args[Keys.ARG_INIT_CALLBACK] =
          PluginUtilities.getCallbackHandle(initCallback)!.toRawHandle();
    }
    if (disposeCallback != null) {
      args[Keys.ARG_DISPOSE_CALLBACK] =
          PluginUtilities.getCallbackHandle(disposeCallback)!.toRawHandle();
    }
    if (initDataCallback != null ){
      args[Keys.ARG_INIT_DATA_CALLBACK] = initDataCallback;
    }
    if(gpsCallBack != null){
      print("Olha o nullcheck::");
      args[Keys.ARG_GPS_CALLBACK] = PluginUtilities.getCallbackHandle(gpsCallBack)!.toRawHandle();
      print("Olha o nullcheck//");
    }

    return args;
  }

  static Map<String, dynamic> _getAndroidArgumentsMap(
      AndroidSettings androidSettings) {
    final Map<String, dynamic> args = {
      Keys.ARG_SETTINGS: androidSettings.toMap()
    };

    if (androidSettings.androidNotificationSettings.notificationTapCallback !=
        null) {
      args[Keys.ARG_NOTIFICATION_CALLBACK] = PluginUtilities.getCallbackHandle(
              androidSettings
                  .androidNotificationSettings.notificationTapCallback!)!
          .toRawHandle();
    }

    return args;
  }

  static Map<String, dynamic> _getIOSArgumentsMap(IOSSettings iosSettings) {
    return iosSettings.toMap();
  }
}
