import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Screen/PageHome.dart';
import 'package:smartpark/Screen/PageLogin.dart';
import 'package:smartpark/Screen/PageVerifyYourAccount.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final User _user = User();
  bool _isEmailVerified = false;

  Future<void> _checkEmailVerification() async{
    _isEmailVerified = await System().isEmailVerified();
    if (_isEmailVerified){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WidgetBottomNavigation()),
        (Route<dynamic> route) => false,
      );
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PageVerifyYourAccount()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<User>(context);

    if (providerUser == null){
      return PageLogin();
    }
    else{
      _checkEmailVerification();
      return PageHome();
    }
  }
}