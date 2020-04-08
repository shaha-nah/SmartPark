import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageChangePassword extends StatefulWidget {
  @override
  _PageChangePasswordState createState() => _PageChangePasswordState();
}

class _PageChangePasswordState extends State<PageChangePassword> {
  final User _user = User();
  String _newPassword = "";
  String _confirmPassword = "";

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

  Widget _widgetNewPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 15,),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          onChanged: (String value){
            setState(() {
              _newPassword = value;
            });
          },
          obscureText: true,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.lock_outline,
                color: hex("#8860d0"),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
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
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }

  Widget _widgetConfirmPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          onChanged: (String value){
            setState(() {
              _confirmPassword = value;
            });
          },
          obscureText: true,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
              hintText: "Confirm Password",
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.lock_outline,
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

  Widget _widgetButtonSave(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1.0],
            colors: [
              hex("#8860d0"),
              hex("#5ab9ea")
            ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Colors.deepPurple),
        child: FlatButton(
          child: Text(
            "Save",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async{
            if (_newPassword != "" && _confirmPassword != ""){
              if (_newPassword.length < 6){
                _dialogError("Please enter a password of at least 6 characters");
              }
              else{
                if (_newPassword != _confirmPassword){
                  _dialogError("Your passwords do not match");
                }
                else{
                  var result = await _user.changePassword(_newPassword);
                  if (result){
                    _dialogSuccess("Password has successfully been changed");
                  }
                  else{
                    _dialogError("Please login again and try again");
                  }
                }
              }
            }
            else{
              _dialogError("Please fill all the fields");
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
        title: Text("Change Password", style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body:ListView(
        children: <Widget>[
          _widgetNewPassword(),
          _widgetConfirmPassword(),
          _widgetButtonSave()
        ], 
      )
    );
  }
}