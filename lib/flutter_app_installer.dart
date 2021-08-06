import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAppInstaller {
  static const MethodChannel _channel = const MethodChannel('flutter_app_installer');

  static Future<String?> get platformVersion async {
    return await _channel.invokeMethod('getPlatformVersion');
  }

  /// Retrieve Android Version Name
  static Future<String?> get versionName async {
    return await _channel.invokeMethod('getVersionName');
  }

  /// Retrieve Android Version Code
  static Future<int?> get versionCode async {
    return await _channel.invokeMethod('getVersionCode');
  }

  /// Check if the device is rooted, return a bool.
  static Future<bool> get isDeviceRooted async {
    return await _channel.invokeMethod('isDeviceRooted');
  }

  /// Check if the application is system application, return a bool.
  static Future<bool> get isSystemApplication async {
    return await _channel.invokeMethod('isSystemApplication');
  }

  /// Check if the application has shell root permission, return a bool.
  static Future<bool> get hasShellRootPermission async {
    return await _channel.invokeMethod('checkShellRootPermission');
  }

  /// Install the apk in the [filePath].
  /// If you want to install the apk [silently], the device need to be system application or has root permission on your emulator.
  ///
  /// After the installation is finished will return a bool.
  static Future<bool> installApk({
    required String filePath,
    bool silently = false,
  }) async {
    return await _channel.invokeMethod(
      "installApk",
      <String, dynamic>{
        "filePath": filePath,
        "silently": silently,
      },
    );
  }
}
