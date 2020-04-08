import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageWallet extends StatefulWidget {
  @override
  _PageWalletState createState() => _PageWalletState();
}

class _PageWalletState extends State<PageWallet> {

  final User _user = User();
  var _amount="";

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
  
  Widget _label(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Text(
          "Enter the amount of money",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _txtCredit(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (String value){
            setState(() => _amount = value);
          },
          decoration: InputDecoration(
            hintText: "Amount",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.attach_money,
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

  Widget _btnRecharge(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            "Recharge",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async {
            if (_amount != ""){
              try{
                if (int.parse(_amount) <= 0){
                  _dialogError("Please enter a positive value");
                }
                else{
                  await _user.recharge(_amount);
                  Navigator.of(context).pop();
                }
              }
              catch(e){
                _dialogError("Please enter a numeric value");
              }
            }
            else{
              _dialogError("Please enter a value");
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
        title: Text(
          "Recharge",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: ListView(
          children: <Widget>[
            _label(),
            _txtCredit(),
            _btnRecharge(),
          ],
        ),
      ),
    );
  }
}