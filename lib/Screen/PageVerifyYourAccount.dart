import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageLogin.dart';

class PageVerifyYourAccount extends StatefulWidget {
  @override
  _PageVerifyYourAccountState createState() => _PageVerifyYourAccountState();
}

class _PageVerifyYourAccountState extends State<PageVerifyYourAccount> {

  void _dialogSuccess(){
    Alert(
      context: context,
      type: AlertType.success,
      title: "SUCCESS!",
      desc: "Email sent",
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
            (Route<dynamic> route) => true,
          ),
          width: 120,
        )
      ],
    ).show();
  }

  final _logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/confirmEmail.png'),
    ),
  );

  Widget _btnBack(){
    return FlatButton(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: hex("#5680e9"),
          ),
          Text(
            'Go Back',
            style: TextStyle(color: hex("#5680e9")),
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(context, RouteTransition(page: PageLogin()));
      },
    );
  }

  Widget _btnResend(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: 800,
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
            "Resend link",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async {
            await System().resendEmailVerification();
            return _dialogSuccess();
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _logo,
          Center(
            child: Text(
              "Verify your account!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 12,),
          Center(
            child: Text(
              "A link has been sent to your email",
            ),
          ),
          SizedBox(height: 20,),
          _btnResend(),
          _btnBack(),
        ], 
      )
    );
  }
}