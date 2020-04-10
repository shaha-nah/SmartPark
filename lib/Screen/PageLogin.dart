import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageForgotPassword.dart';
import 'package:smartpark/Screen/PageRegister.dart';
import 'package:flutter/gestures.dart';
import 'package:smartpark/Wrapper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class PageLogin extends StatefulWidget{
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin>{
  final User _user = User();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';

  final _logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/logo.jpg'),
    ),
  );
  
  void _dialogError(){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: "Invalid Credentials.",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Try Again",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
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
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
  }

  Widget _txtPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          onChanged: (String value){
            setState(() => password = value);
          },
          cursorColor: Colors.deepPurple,
          obscureText: true,
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

  Widget _btnLogin(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()){
              dynamic result = await _user.signIn(email, password);
              if (result == null){
                setState(() {
                  _dialogError();
                });
              }
              else{
                Navigator.push(context, RouteTransition(page: Wrapper()));
              }
            }
          },
        ),
      )
    );
  }

  Widget _btnForgotPassword(){
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Forgot password?',
        style: TextStyle(
          color: hex("#5680e9")
        ),
      ),
      onPressed: () {
        Navigator.push(context, RouteTransition(page: PageForgotPassword()));
      },
    );
  }

  Widget _divider(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row( 
        children: <Widget>[
          Expanded(
            child: Divider(),
          ),
          SizedBox(width: 5,),
          Text("OR"),
          SizedBox(width: 5,),
          Expanded(
            child: Divider(),
          ),
        ],
      )
    );
  }

  Widget _btnRegister(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          style: new TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold
          ),
          children: <TextSpan>[
            new TextSpan(
              text: 'Not a member? '
            ),
            new TextSpan(
              text: 'Create an Account', 
              style: new TextStyle(
                color: hex("#5680e9"),
                fontWeight: FontWeight.bold
              ),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                Navigator.push(context, RouteTransition(page: PageRegister()));              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _logo,
            _txtEmail(),
            _txtPassword(),
            _btnLogin(),
            _btnForgotPassword(),
            _divider(),
            _btnRegister(),
          ],
        ),
      ) 
    );
  }
}