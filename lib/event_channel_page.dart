import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class EventChannelPage extends StatefulWidget {
  EventChannelPage({Key key}) : super(key: key);

  @override
  _EventChannelPageState createState() => _EventChannelPageState();
}

class _EventChannelPageState extends State<EventChannelPage> {
   StreamController<bool> streamController = StreamController();

  @override
  void initState() {
    _handleLocationChanges();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Events channel",
            style: new TextStyle(color: Colors.white),
          ),
        ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location Service status:'),
              StreamBuilder<bool>(builder: (context,snapshot){
                if(snapshot.hasData)
                  {
                    return Text(snapshot.data ? 'is On': 'is Off');
                  }
                else
                  {
                    return  Text('Unknown result');
                  }
              },
              stream: streamController.stream,
              ),
        ]
      ),
    ),
    );
  }

  void _handleLocationChanges() async {
    var status = await Permission.location.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
      status = await Permission.location.request();
    }

// You can can also directly ask the permission about its status.
    if (status.isGranted) {
      const EventChannel _stream = EventChannel('locationStatusStream');

      bool _locationStatusChanged;
      if (_locationStatusChanged == null) {
        _stream.receiveBroadcastStream().listen((onData) {
          _locationStatusChanged = onData;
          print("LOCATION ACCESS IS NOW ${onData ? 'On' : 'Off'}");
          if (onData == false) {
            // Request Permission Access
          }
          streamController.add(_locationStatusChanged);
        });
      }
    } else {
      streamController.add(null);
    }
  }
}