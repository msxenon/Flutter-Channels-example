import 'package:flutter/material.dart';
import 'package:flutter_channels_demo/event_channel_page.dart';
import 'package:flutter_channels_demo/method_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Channels demo'),
    );
  }

  void testFeature(){
    //added on test_feature branch
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EventChannelPage();
              }));
            },child: Text("Event type Channel",),),
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return MethodChannelPage();
              }));
            },child: Text("Method type Channel",),),
          ],
        ),
      )
    );
  }
}
