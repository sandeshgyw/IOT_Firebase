import 'package:flutter/material.dart';
import 'package:iotfirebase/screens/iotscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{},
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IotScreen(),
      // home: AuthService().handleAuth(),
    );
  }
}
