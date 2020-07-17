import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:iotfirebase/button_widget.dart';

import 'package:iotfirebase/constants.dart';

class IotScreen extends StatefulWidget {
  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Color glowcolor = Colors.lightBlueAccent;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: -1.0, end: 2.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  final dbRef = FirebaseDatabase.instance.reference();
  bool value = false;
  Color color = Colors.grey;
  String state = "OFF";

  void onUpdate() {
    setState(() {
      color = Colors.yellow;
      state = "ON";
      value = !value;
    });
  }

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      // title: 'Welcome to Flutter',
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("DRAWER HEADER.."),
              decoration: new BoxDecoration(color: Colors.orange),
            ),
            new ListTile(
              title: new Text("Item => 1"),
              onTap: () {},
            ),
            new ListTile(
              title: new Text("Item => 2"),
              onTap: () {},
            ),
          ],
        )),
        body: SafeArea(
          child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data.snapshot.value != null) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: CircularSoftButton(
                              icon: Icon(Icons.clear_all),
                            ),
                          ),
                          Text("MY ROOM",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          CircularSoftButton(
                            icon: Icon(Icons.settings),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Temperature",
                                      style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  margin: EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Text(
                                      snapshot.data.snapshot
                                              .value["Temperature:"]
                                              .toString() +
                                          "°C",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 40)),
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     color: Colors.lightBlueAccent,
                                    //     width: 2),
                                    borderRadius: BorderRadius.circular(200),
                                    gradient: LinearGradient(
                                      colors: [shadowColor, lightShadowColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: glowcolor,
                                        // offset: Offset(8, 6),
                                        spreadRadius: _animation.value,
                                        // blurRadius: _animation.value
                                      ),
                                      BoxShadow(
                                        spreadRadius: _animation.value,
                                        // blurRadius: _animation.value,
                                        color: glowcolor,
                                        // offset: Offset(-8, -6),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Humidity",
                                      style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                      snapshot.data.snapshot.value["Humidity:"]
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 40)),
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     color: Colors.lightBlueAccent,
                                    //     width: 2),
                                    borderRadius: BorderRadius.circular(200),
                                    gradient: LinearGradient(
                                      colors: [shadowColor, lightShadowColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: _animation.value,
                                        // blurRadius: _animation.value,
                                        color: glowcolor,
                                        // offset: Offset(8, 6),
                                      ),
                                      BoxShadow(
                                        spreadRadius: _animation.value,
                                        // blurRadius: _animation.value,
                                        color: glowcolor,
                                        // offset: Offset(-8, -6),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FloatingActionButton.extended(
                          icon: value
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          backgroundColor: value ? Colors.yellow : Colors.cyan,
                          label: value ? Text("ON") : Text("OFF"),
                          elevation: 20.00,
                          onPressed: () {
                            onUpdate();
                            writeData();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AnimatedContainer(
                            width: value ? 200 : 100,
                            height: value ? 200 : 100,
                            curve: Curves.decelerate,
                            duration: Duration(milliseconds: 400),
                            // color: value ? Colors.yellow : Colors.grey,
                            child: value
                                ? Image.asset(
                                    "assets/1.png",
                                    // height: 120.0,
                                    // width: 80.0,
                                  )
                                : Image.asset(
                                    "assets/2.png",
                                    // height: 120.0,
                                    // width: 80.0,
                                  )),
                      )
                    ],
                  );
                } else {}
                return Container();
              },
              stream: dbRef.child("Data").onValue),
        ),
      ),
    );
  }

  Future<void> writeData() async {
    dbRef.child("LightState").set({"switch": !value});
  }

  Future<void> readData() async {
    dbRef.child("Data").once().then((DataSnapshot snapshot) {
      print(snapshot.value);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
