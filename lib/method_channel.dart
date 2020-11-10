import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelPage extends StatefulWidget {

  MethodChannelPage({Key key}) : super(key: key);

  @override
  _MethodChannelPageState createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  String _deviceData = 'Loading..';
  static const platform = const MethodChannel('modi/deviceInfo');
  @override
  void initState() {
    getDeviceInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_deviceData),
      ),
    );
  }

  Future<void> getDeviceInfo() async {
    String deviceInfo;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = result;
    } catch (e) {
      deviceInfo = "Failed to device info: '${e.message}'.";
    }
    _deviceData = deviceInfo;
    if(mounted)
    setState(() {
    });

  }
}