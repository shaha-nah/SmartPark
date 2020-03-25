// import 'package:flutter/material.dart';
// import 'package:shared_preferences_settings/shared_preferences_settings.dart';
// import 'package:smartpark/Model//User.dart';
// import 'package:smartpark/Screen/PageChangeEmail.dart';
// import 'package:smartpark/Screen/PageChangeName.dart';
// import 'package:smartpark/Screen/PageChangePassword.dart';
// import 'package:smartpark/Screen/PageDeleteAccount.dart';
// import 'package:smartpark/Service/ServiceAuth.dart';

// class PageSettings extends StatefulWidget {
//   @override
//   _PageSettingsState createState() => _PageSettingsState();
// }

// class _PageSettingsState extends State<PageSettings> {

//   final User _user = User();
//   // final ServiceAuth _auth = ServiceAuth();

//   bool _notification = false;
//   bool _location = true;

//   Widget _changeName(){
//     return Container(
//       height: 50.0, // Change as per your requirement
//       width: 300.0, // Change as per your requirement
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 1,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.person, color: Colors.deepPurple),
//             title: Text('Name',),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => PageChangeName()));
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _changeEmail(){
//     return Container(
//       height: 50.0, // Change as per your requirement
//       width: 300.0, // Change as per your requirement
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 1,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.email, color: Colors.deepPurple),
//             title: Text('Email',),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => PageChangeEmail()));
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _changePassword(){
//     return Container(
//       height: 50.0, // Change as per your requirement
//       width: 300.0, // Change as per your requirement
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 1,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.lock, color: Colors.deepPurple,),
//             title: Text('Password',),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => PageChangePassword()));
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _notificationPermission(){
//     return SwitchListTile(
//       activeColor: Colors.deepPurple,
//       title: Row(
//         children: <Widget>[
//           Icon(
//             Icons.notifications,
//             color: Colors.deepPurple,
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
//             color: Colors.deepPurple,
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
//     );
//   }

//   //   Widget _pushNotification(){
//   //   return Container(
//   //     height: 50.0, // Change as per your requirement
//   //     width: 300.0, // Change as per your requirement
//   //     child: ListView.builder(
//   //       shrinkWrap: true,
//   //       itemCount: 1,
//   //       itemBuilder: (BuildContext context, int index) {
//   //         return ListTile(
//   //           leading: Icon(Icons.notifications),
//   //           title: Text('Push Notification',),
//   //           onTap: () {},
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

//     Widget _logout(){
//       return Container(
//         height: 50.0, // Change as per your requirement
//         width: 300.0, // Change as per your requirement
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: 1,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               leading: Icon(
//                 Icons.power_settings_new,
//                 color: Colors.deepPurple,
//               ),
//               title: Text(
//                 'Logout',
//                 style: TextStyle(
//                 ),
//               ),
//               onTap: () async {
//                 await _user.signOut(context);
//               },
//             );
//           },
//         ),
//       );
//     }

//     Widget _deleteAccount(){
//     return Container(
//       height: 50.0, // Change as per your requirement
//       width: 300.0, // Change as per your requirement
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 1,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(
//               Icons.delete,
//               color: Colors.deepPurple,
//             ),
//             title: Text(
//               'Delete Account',
//               style: TextStyle(
//               ),
//             ),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => PageDeleteAccount()));
//             },
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: new AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text("Settings", style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 5.0,
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           children: <Widget>[
//             SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 20.0),
//               child: Text(
//                 "Account", 
//                 style: TextStyle(
//                   color: Colors.black54
//                 ),
//               ),
//             ),
//             _changeName(),
//             _changeEmail(),
//             _changePassword(),
//             _logout(),
//             _deleteAccount(),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 20.0),
//               child: Text(
//                 "Permissions", 
//                 style: TextStyle(
//                   color: Colors.black54
//                 ),
//               ),
//             ),
//             _notificationPermission(),
//             _locationPermission(),
//             // RaisedButton(
//             //   child: Text("Logout"),
//             //   onPressed: ()async {
//             //     await _auth.signOut(co);
//             //   },
//             // ),
//           ]
//         ),
//       )
//     );
//   }
// } 