// import 'package:division/division.dart';
// import 'package:flutter/material.dart';
// import 'package:smartpark/Model//User.dart';

// class PageNotification extends StatefulWidget {
//   @override
//   _PageNotificationState createState() => _PageNotificationState();
// }

// class _PageNotificationState extends State<PageNotification> {

//   final User _user = User();
//   // final ServiceAuth _auth = ServiceAuth();

//   bool _notification = false;
//   bool _location = true;

//   Widget _notificationPermission(){
//     return SwitchListTile(
//       activeColor: Colors.deepPurple,
//       title: Row(
//         children: <Widget>[
//           Icon(
//             Icons.notifications,
//             color: (hex("#5680e9")),
//           ),
//           SizedBox(
//             width: 33,
//           ),
//           Text("Push Notifications")
//         ],
//         // leading: Icon(Icons.notifications),
//         // title: Text("Push Notifications")
//       ),
//       value: _notification,
//       onChanged: (bool val){
//         setState((){
//           _notification = val;
//         });
//       },
//       // secondary: const Icon(Icons.notifications),
//     );
//   }

//   Widget _locationPermission(){
//     return SwitchListTile(
//       activeColor: Colors.deepPurple,
//       title: Row(
//         children: <Widget>[
//           Icon(
//             Icons.location_on,
//             color: (hex("#5680e9")),
//           ),
//           SizedBox(
//             width: 33,
//           ),
//           Text("Location")
//         ],
//       ),
//       value: _location,
//       onChanged: (bool val){
//         setState((){
//           _location = val;
//         });
//       },
//       // secondary: const Icon(Icons.notifications),
//       // activeTrackColor: (hex("#5680e9")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: new AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text("Push Notifications", style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 5.0,
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           children: <Widget>[
//             _notificationPermission(),
//             _locationPermission(),
//           ]
//         ),
//       )
//     );
//   }
// } 