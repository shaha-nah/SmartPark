import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageRegister extends StatefulWidget{
  @override
  _PageRegisterState createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister>{
  final User _user = User();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  final _logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/logo.jpg'),
    ),
  );
  
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

  Widget _txtName(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          onChanged: (String value){
            setState(() => name = value);
          },
          decoration: InputDecoration(
            hintText: "Name",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.person_outline,
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

  Widget _txtEmail(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (String value){
            setState(() => email = value);
          },
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
            contentPadding:EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
  }

  Widget _txtPhoneNumber(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (String value){
            setState(() => phoneNumber= value);
          },
          decoration: InputDecoration(
            hintText: "Phone Number",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.phone,
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
        child: TextFormField(
          onChanged: (String value){
            setState(() => password = value);
          },
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

  Widget _txtConfirmPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          onChanged: (String value){
            setState(() => confirmPassword = value);
          },
          obscureText: true,
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
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
  }

  Widget _btnRegister(){
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
            "Register",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18
            ),
          ),
          onPressed: () async {
            if (name != "" && email != "" && phoneNumber != "" && password != "" && confirmPassword != ""){
              if (phoneNumber.length == 8){
                if (password == confirmPassword){
                  dynamic result =  await _user.signUp(name, email, phoneNumber, password, context);
                  if (result != null){
                    _dialogError(result);
                  }
                }
                else{
                  _dialogError("Passwords do not match. Please try again");
                }
              }
              else{
                _dialogError("Phone number is invalid");
              }
            }
            else{
              _dialogError("Please fill in all the fields");
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
      body:Form(
        key: _formKey, 
        child: ListView(
          children: <Widget>[
            _logo,
            _txtName(),
            _txtEmail(),
            _txtPhoneNumber(),
            _txtPassword(),
            _txtConfirmPassword(),
            _btnRegister(),
          ],
        ),
      )
    );
  }
}