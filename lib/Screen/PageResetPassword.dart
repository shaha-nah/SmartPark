// import 'package:division/division.dart';
// import 'package:flutter/material.dart';
// import 'package:smartpark/Screen/PageForgotPassword.dart';

// import 'PageLogin.dart';

// class PageResetPassword extends StatefulWidget {
//   static String tag = 'resetPassword-page';
//   @override
//   _PageResetPasswordState createState() => new _PageResetPasswordState();
// }

// class _PageResetPasswordState extends State<PageResetPassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: new AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text("Reset Password", style: TextStyle(color: Colors.black),
//         ),
//         // centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 5.0,
//       ),
//       body:ListView(
//         children: <Widget>[
//           SizedBox(
//             height: 30,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32),
//             child: Text("Enter your new password."),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32),
//             child: Material(
//               elevation: 2.0,
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               child: TextField(
//                 onChanged: (String value){},
//                 cursorColor: Colors.deepPurple,
//                 decoration: InputDecoration(
//                     hintText: "Password",
//                     prefixIcon: Material(
//                       elevation: 0,
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       child: Icon(
//                         Icons.lock_outline,
//                         color: hex("#8860d0"),
//                       ),
//                     ),
//                     border: InputBorder.none,
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32),
//             child: Material(
//               elevation: 2.0,
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               child: TextField(
//                 onChanged: (String value){},
//                 cursorColor: Colors.deepPurple,
//                 decoration: InputDecoration(
//                     hintText: "Confirm Password",
//                     prefixIcon: Material(
//                       elevation: 0,
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       child: Icon(
//                         Icons.lock_outline,
//                         color: hex("#8860d0"),
//                       ),
//                     ),
//                     border: InputBorder.none,
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32,),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   stops: [0.1, 1.0],
//                   colors: [
//                     hex("#8860d0"),
//                     hex("#5ab9ea")
//                   ]
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(100)),
//                 color: Colors.deepPurple),
//               child: FlatButton(
//                 child: Text(
//                   "Reset Password",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18),
//                 ),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => PageLogin()));
//                 },
//               ),
//             )
//           ),
//         ], 
//       )
//     );
//   }
// }