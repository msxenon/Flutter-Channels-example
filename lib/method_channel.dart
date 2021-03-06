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
      appBar: new AppBar(
        title: new Text(
          "Method channel",
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
          Text('Device info is:'),
          Text(_deviceData)]),
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