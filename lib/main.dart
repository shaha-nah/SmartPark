import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:  User().user,
      child: MaterialApp(
        title: 'SmartPark',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Nunito',
          canvasColor: Colors.white,
          accentColor: Colors.deepPurple,
        ),
        home: Wrapper(),
      ),
    );
  }
}