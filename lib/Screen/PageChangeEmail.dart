// import 'package:division/division.dart';
// import 'package:flutter/material.dart';
// import 'package:smartpark/Model/User.dart';
// import 'package:smartpark/Screen/PageProfile.dart';

// class PageChangeEmail extends StatefulWidget {
//   @override
//   _PageChangeEmailState createState() => _PageChangeEmailState();
// }

// class _PageChangeEmailState extends State<PageChangeEmail> {
//   final User _user = User();

//   String email = '';


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: new AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text("Change Email", style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
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
//             child: Text("Enter your new email."),
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
//                 keyboardType: TextInputType.emailAddress,
//                 onChanged: (String value){
//                   email= value;
//                 },
//                 cursorColor: Colors.deepPurple,
//                 decoration: InputDecoration(
//                     hintText: "Email",
//                     prefixIcon: Material(
//                       elevation: 0,
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       child: Icon(
//                         Icons.mail_outline,
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
//                   "Save",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18),
//                 ),
//                 onPressed: () async{
//                   await _user.changeEmail(email);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             )
//           ),
//         ], 
//       )
//     );
//   }
// }