import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _versionName = 'Unknown';
  int _versionCode = 0;
  bool _isDeviceRooted = false;
  bool _isSystemApplication = false;
  bool _hasShellRootPermission = false;
  late File _testInstallApk;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initVersion();
    initIsDeviceRooted();
    initIsSystemApplication();
    initHasShellRootPermission();
    initTestApkFile();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterAppInstaller.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initVersion() async {
    String? versionName = await FlutterAppInstaller.versionName;
    int? versionCode = await FlutterAppInstaller.versionCode;

    setState(() {
      _versionName = versionName ?? "Unknown Version Name";
      _versionCode = versionCode ?? 0;
    });
  }

  Future<void> initIsDeviceRooted() async {
    bool isDeviceRooted = await FlutterAppInstaller.isDeviceRooted;
    setState(() {
      _isDeviceRooted = isDeviceRooted;
    });
  }

  Future<void> initIsSystemApplication() async {
    bool isSystemApplication = await FlutterAppInstaller.isSystemApplication;
    setState(() {
      _isSystemApplication = isSystemApplication;
    });
  }

  Future<void> initHasShellRootPermission() async {
    bool hasShellRootPermission = await FlutterAppInstaller.hasShellRootPermission;
    setState(() {
      _hasShellRootPermission = hasShellRootPermission;
    });
  }

  Future<void> initTestApkFile() async {
    final filename = 'test-install.apk';
    var bytes = await rootBundle.load("assets/$filename");
    String path = "${(await getExternalStorageDirectory())!.uri.toFilePath()}$filename";

    final buffer = bytes.buffer;
    _testInstallApk = await new File(path).writeAsBytes(
      buffer.asUint8List(
        bytes.offsetInBytes,
        bytes.lengthInBytes,
      ),
    );
  }

  void startInstallTestApkNormal() {
    FlutterAppInstaller.installApk(
      filePath: _testInstallApk.path,
    );
  }

  void startInstallTestApkSilently() {
    FlutterAppInstaller.installApk(
      filePath: _testInstallApk.path,
      silently: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App Installer Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion'),
              Text('Version: $_versionName($_versionCode)'),
              Text("Device Rooted: $_isDeviceRooted"),
              Text("Is Application System Application: $_isSystemApplication"),
              Text("Application has shell root permission: $_hasShellRootPermission"),
              OutlinedButton(
                onPressed: startInstallTestApkNormal,
                child: Text("Install Test Apk Normal"),
              ),
              OutlinedButton(
                onPressed: startInstallTestApkSilently,
                child: Text("Install Test Apk Silently"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
