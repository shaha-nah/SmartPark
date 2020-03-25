// import 'package:division/division.dart';
// import 'package:flutter/material.dart';
// import 'package:smartpark/Model/User.dart';
// import 'package:smartpark/Screen/PageProfile.dart';
// import 'package:smartpark/Screen/PageSettings.dart';

// class PageChangeName extends StatefulWidget {
//   @override
//   _PageChangeNameState createState() => _PageChangeNameState();
// }

// class _PageChangeNameState extends State<PageChangeName> {

//   static final User _user = User();
//   final _formKey = GlobalKey<FormState>();
  
//   String name = '';
  
//   // static void popUntil(BuildContext context, RoutePredicate predicate) {
//   //   Navigator.of(context).popUntil(predicate);
//   // }

//   void _dialogError(context){
//     showDialog(
//       context: context,
//       builder: (BuildContext context){
//         return AlertDialog(
//           //title:
//           content: new Text("Please enter your name"),
//           actions: <Widget>[
//             new FlatButton(
//               child: new Text("OK"),
//               onPressed: (){
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       }
//     );
//   }

//   Widget _lblTitle(){
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//       child: Text(
//         "Enter your new name",
//       ),
//     );
//   }

//   Widget _txtName(){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//       child: Material(
//         elevation: 2.0,
//         borderRadius: BorderRadius.all(Radius.circular(30)),
//         child: TextFormField(
//           // validator: (value){
//           //   if (value.isEmpty){
//           //     _dialogError(context);
//           //   }
//           // },
//           // validator: (value) => value.isEmpty ? 'Please enter a name.' : null,
//           onChanged: (String value){
//             setState(() => name = value);
//           },
//           decoration: InputDecoration(
//               hintText: "Name",
//               prefixIcon: Material(
//                 elevation: 0,
//                 borderRadius: BorderRadius.all(Radius.circular(30)),
//                 child: Icon(
//                   Icons.person_outline,
//                   color: hex("#8860d0"),
//                 ),
//               ),
//               border: InputBorder.none,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//         ),
//       ),
//     );
//   }

//   Widget _btnSave(){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(100)),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.1, 1.0],
//             colors: [
//               hex("#8860d0"),
//               hex("#5ab9ea")
//             ]
//           )
//         ),
//         child: FlatButton(
//           child: Text(
//             "Save",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18),
//           ),
//           onPressed: () async {
//             if (_formKey.currentState.validate()){
//               _user.changeName(name);
//               // Navigator.popUntil(context, ModalRoute.withName('PageProfile'));
//               Navigator.of(context).pop();
//             }
//             else{
//               return _dialogError(context);
//             }
//           }
//         ),
//       )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: new AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black,
//         ),
//         title: Text("Change name", style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 5.0,
//       ),
//       body:Form(
//         key: _formKey, 
//         child: ListView(
//           children: <Widget>[
//             _lblTitle(),
//             _txtName(),
//             _btnSave(),
//             // _txtErrorMessage()
//           ],
//         ),
//       )
//     );
//   }
// }