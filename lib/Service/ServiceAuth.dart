// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smartpark/Model/User.dart';
// import 'package:smartpark/Service/ServiceDatabase.dart';
// import 'package:smartpark/Wrapper.dart';

// class ServiceAuth{

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //create user object based on firebase user
//   User _userFromFirebaseUser(FirebaseUser user){
//     return user != null? User(uid: user.uid) : null;
//   }

//   //auth change user stream
//   Stream<User> get user{
//     return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
//   }

//   //sign in anonymously
//   Future signInAnon() async{
//     try{
//       AuthResult  result = await _auth.signInAnonymously();
//       FirebaseUser user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch(e){
//       print(e.toString());
//       return null;
//     }
//   }

//   //login with email and password 
//   Future signIn(String email, String password) async{
//     try{
//       AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       FirebaseUser user = result.user;

//       return user;
//     }
//     catch (e){
//       print (e.toString());
//       return null;
//     }
//   }

//   //register with email and password
//   Future signUp(String name, String email, String password, context) async {
//     try{
//       AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       FirebaseUser user = result.user;

//       //create a new document for the user with the uid
//       await ServiceDatabase(uid: user.uid).updateUserData(name, 'normal', 1000, '').then((_){
//         Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
//     });

//       return _userFromFirebaseUser(user);
//     } 
//     catch(e){
//       print(e.toString());
//       return null;
//     }
//   }

//   //logout
//   Future signOut(context) async{
//     try{
//       await _auth.signOut().then((_){
//         Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
//     });
//     }
//     catch(e){
//       print(e.toString());
//       return null;
//     }
//   }
// }