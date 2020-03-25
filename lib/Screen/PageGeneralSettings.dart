import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageGeneralSettings extends StatefulWidget {
  String name;
  String phoneNumber;

  PageGeneralSettings({Key key, @required this.name, @required this.phoneNumber}): super(key:key);
  @override
  _PageGeneralSettingsState createState() => _PageGeneralSettingsState();
}

class _PageGeneralSettingsState extends State<PageGeneralSettings> {
  final User _user = User();
  String name = "";
  String phoneNumber = "";

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

  Widget _btnSave(){
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
            "Save",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async {
            if (name == ""){
              name = widget.name;
            }
            if(phoneNumber == ""){
              phoneNumber = widget.phoneNumber;
            }
            if (phoneNumber.length == 8){
              await _user.editProfile(name, phoneNumber);
              Navigator.of(context).pop();
            }
            else{
              _dialogError("Invalid phone number");
            }
          }
        ),
      )
    );
  }
  
  Widget txtFields(){
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Text(
              "Enter your new name",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TextFormField(
              initialValue: widget.name,
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Text(
              "Enter your new phone number",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TextFormField(
              initialValue: widget.phoneNumber,
              onChanged: (String value){
                setState(() => phoneNumber = value);
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
            ),
          ),
        ),
      ],
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
        title: Text("General Settings", style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: ListView(
        children: <Widget>[
          // Expanded(
            // child: 
            txtFields(),
          // ),
          _btnSave()
        ],
      ),
    );
  }
}