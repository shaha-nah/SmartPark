import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageVehicleForm extends StatefulWidget{
  @override
  _PageVehicleFormState createState() => new _PageVehicleFormState();
}

class _PageVehicleFormState extends State<PageVehicleForm>{ 
  String vehicleLicensePlateNumber = "";

  void _dialogError(){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: "Vehicle already exists.",
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
          onPressed: () => Navigator.pop(context, () {
            initState();
          }),
          width: 120,
        )
      ],
    ).show();
  }
  
  Widget _lblTitle(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text(
        "Enter your license plate number",
      ),
    );
  }

  Widget _txtLicensePlateNumber(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          onChanged: (String value){
            vehicleLicensePlateNumber = value;
          },
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            hintText: "License Plate Number",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.directions_car,
                color: hex("#8860d0")
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
  }

  Widget _btnSave(){
    bool _btnDisabled = false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
          color: Colors.deepPurple
        ),
        child: FlatButton(
          child: Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
          ),
          onPressed: () async {
            if (!_btnDisabled){
              setState(() {
                _btnDisabled = !_btnDisabled;
              });
              var result = await User().addVehicle(vehicleLicensePlateNumber);
              if (result){
                Navigator.of(context).pop();
              }
              else{
                _dialogError();
              }
            }
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Vehicle Details", style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: ListView(
        children: <Widget>[
          _lblTitle(),
          _txtLicensePlateNumber(),
          _btnSave(),
        ],
      ),
    );
  }
}