import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Screen/PageLogin.dart';

import 'PageResetPassword.dart';

class PageForgotPassword extends StatefulWidget {
  static String tag = 'forgotPassword-page';
  @override
  _PageForgotPasswordState createState() => new _PageForgotPasswordState();
}

class _PageForgotPasswordState extends State<PageForgotPassword> {
  String email = "";

  void _dialogError(error){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: error,
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Try Again",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void _dialogSuccess(message){
    Alert(
      context: context,
      type: AlertType.success,
      title: "SUCCESS!",
      desc: message,
      buttons: [
        DialogButton(
          color: Colors.green,
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageLogin()),
            (Route<dynamic> route) => false,
          ),
          width: 120,
        )
      ],
    ).show();
  }

  Widget _lblEmail(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text("Enter the email you use to sign in and we'll send you a link to reset your password."),
    );
  }

  Widget _txtEmail(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (String value){
            setState(() => email = value);
          },
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.mail_outline,
                  color: hex("#8860d0"),
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget _btnSendRequest(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1.0],
            colors: [
              hex("#8860d0"),
              hex("#5ab9ea")
            ]
          )
        ),
        child: FlatButton(
          child: Text(
            "Send Request",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          onPressed: () async{
            var result = await System().sendPasswordResetMail(email);
            if (result){
              _dialogSuccess("A link has been sent to your email");
            }
            else{
              _dialogError("Email does not exist");
            }
          },
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Forgot Password?", style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body:ListView(
        children: <Widget>[
          _lblEmail(),
          _txtEmail(),
          _btnSendRequest()
        ], 
      )
    );
  }
}